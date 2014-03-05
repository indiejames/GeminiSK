----------------------------------------------------------------------------------
--
-- scene_template.lua
--
----------------------------------------------------------------------------------

local director = require( "director" )
local ui = require("ui")
local action = require("action")
local timer = require("timer")
local shape = require("shape")
local node = require("node")
local sprite = require("sprite")
local sound = require("sound")
local physics = require("physics")
local texture = require("texture")
local path = require("path")
local emitter = require("emitter")


local physicsData = require('mario_game_physics').physicsData(1)

local scene = director.newScene()




local zoomNode
local panNode
local label2 
local circle
local rectangle
local rotation
local pan
local runner
local animate
local rep
local pbody
local sceneBodby
local myPath
local ship
local shipPath
local shipPath2
local shipSound
local soundPlayer

local box = {}

local box_positions = { 
                        -- floor
                         16, 16,
                         48, 16,
                         80, 16,
                        112, 16,
                        144, 16,
                        176, 16,
                        208, 16,
                        240, 16,
                        272, 16,
                        304, 16,
                        336, 16,
                        368, 16,
                        400, 16,
                        432, 16,
                        464, 16,
                        
                        528, 16,
                        560, 16,
                        
                        
                        -- left platform
                        16, 80,
                        48, 80,
                        
                        
                        
                        -- right platform
                        240, 112,
                        272, 112,


                        }
                        

local platform_speed = 0.5                        
local platform = {}
local platform_position = {
                        -- moving platform
                        176, 112,
                        208, 112,
                        }

local wall = {}

local wall_positions = {
                        -- wall
                        496, 16,
                        496, 48,
                        496, 80,
                        496, 112,
                        496, 144,
                        }

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
  print("Lua: Creating scene3")
  scene:setSize(568,320)
  scene:setBackgroundColor(0.37,0.58,0.99)
  physics.setDebug(true)
  --physics.setSimulationSpeed(0.01)
  physics.setGravity(0,-4.5)
  physics.setScale(20)
  
  
  texture_atlas = texture.newTextureAtlas("8bit")
  texture1 = texture.newTexture(texture_atlas, "mario.01.png")

  block_texture = texture.newTexture(texture_atlas, "brick.png")
  coin_texture = texture.newTexture(texture_atlas, "coin.png")

 
  runner = sprite.newSprite(texture1)
  runner.xScale = -1 * runner.xScale
  runner.name = "mario"
  scene:addChild(runner)
  runner:setPosition(100, 148)
  physics.addBody(runner, "dynamic", physicsData:get("mario"))
  
  frames =  {
  "mario.01.png",
  "mario.02.png",
  "mario.03.png",
  "mario.02.png",
  "mario.01.png",
  "mario.04.png",
  "mario.05.png",
  "mario.04.png"
  }
  
textures = {}
for i, file in ipairs(frames) do
    textures[i] = texture.newTexture(texture_atlas, file)
end

  animate = action.animate(textures[1], textures[2], textures[3], textures[4], textures[5], textures[6], textures[7], textures[8], 0.1)

 
  -- boxes

    
    local num_boxes = #box_positions / 2
    
    for i = 0, num_boxes-1 do
        local x = box_positions[i*2+1]
        local y = box_positions[i*2+2]
        
        box[i+1] = sprite.newSprite(block_texture)
        box[i+1].name = "block" .. (i+1)
        box[i+1]:setPosition(x,y)
        scene:addChild(box[i+1])
    

        print ("Lua: getting physics")
        --pd = physicsData:get("brick_block")
        --print(pd)
        physics.addBody(box[i+1], "static", physicsData:get("brick_block"))
        box[i+1].isActive = false
    end

    print "Lua: boxes added"
    
    -- wall
    local num_wall_blocks = #wall_positions / 2
    for i = 0, num_wall_blocks-1 do
        local x = wall_positions[i*2+1]
        local y = wall_positions[i*2+2]
        
        wall[i+1] = sprite.newSprite(block_texture)
       
        wall[i+1].name = "wall" .. (i+1)
        wall[i+1]:setPosition(x,y)
        scene:addChild(wall[i+1])
    
        physics.addBody(wall[i+1], "kinematic", physicsData:get("brick_block"))
        --wall[i+1].isActive = false
    end

    print "Lua: wall added"
        
    -- platform
    local num_platform_blocks = #platform_position / 2
    for i = 0, num_platform_blocks-1 do
        local x = platform_position[i*2+1]
        local y = platform_position[i*2+2]
        
        platform[i+1] = sprite.newSprite(block_texture)
        
        platform[i+1].name = "platform" .. (i+1)
        platform[i+1]:setPosition(x,y)
        scene:addChild(platform[i+1])
    
        physics.addBody(platform[i+1], "kinematic", physicsData:get("platform_block"))
        --platform[i+1].isActive = false
    end

    print "Lua: platform added"
    
    -- coin
    coin = sprite.newSprite(coin_texture)
    --coin:prepare("coin")
    coin.name = "coin"
    coin:setPosition(272, 144)
    
    physics.addBody(coin, "static", physicsData:get("coin"))
   -- coin.isActive = false
    scene:addChild(coin)

    print "Lua: coin added"

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

  -----------------------------------------------------------------------------
  
  print("Entering scene 3")

  director.destroyScene("scene2")

  rep = action.repeatAction(animate,-1)
  
  --followPath = action.followPath(myPath, 3, true, false)


  runner:runAction(rep)
  --runner:runAction(rotation)
  --runner:runAction(followPath)

  
  --rep = action.repeatAction(animate,-1)
  --rotation = action.rotate(7.0, 3)
  --followPath = action.followPath(myPath, 3, true, false)


  --runner:runAction(rep)
  --runner:runAction(rotation)
  --runner:runAction(followPath)

  function runner:touchesBegan ()
    print ("Runner touched")
  end


end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  
    --Runtime:removeEventListener("enterFrame", scene.starListener)
   
    
    print("Exiting scene 3")

  end

-- Called when the scene physics have been simulated
function scene:didSimulatePhysics()

end

-- Called when scenes actions have been updated
function scene:didEvaluateActions()
    
end

-- Called when the scene's size changes
function scene:didChangeSize(width, height)

end

-- Called once every frame
function scene:update(currentTime)
    -----------------------------------------
    
    --  It is not recommended to use this   --
    --  method for animation - use physics --
    --  and actions instead.                   --
    
    -----------------------------------------
  end

-- Called when scene is deallocated
function scene:destroyScene(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. remove listeners, widgets, save state, etc.)

  -----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene