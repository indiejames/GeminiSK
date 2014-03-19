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

local WALKING_VELOCITY = 0.5
local TERMINAL_VELOCITY = 10.0

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
  print("Lua: Creating scene3")
  scene:setSize(568,320)
  scene:setBackgroundColor(0.37,0.58,0.99)
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
  physics.setAllowsRotation(runner, false)
  
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

  runner.state = "STANDING"
  rightButtonState = 0
  leftButtonState = 0
  jumpButtonState = 0

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
    return true
  end

  function runner:touchesEnded(evt)
    print ("Runner touch ended")
    return false
  end

  function runner:didBeginContact(evt)
    --print ("Runner contact began")
  end

  function runner:didEndContact(evt)
    --print ("Runner contact ended")
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
  setRunnerState()
end

-- Called when the scene's size changes
function scene:didChangeSize(width, height)

end

function setRunnerState()
  vx, vy = physics.getVelocity(runner)

  -- TODO - this could be triggered at the top of a jump, which is not correct
  if vy == 0 and runner.state == "JUMPING" then
    runner.state = "STANDING"
  end

  if rightButtonState == 1 then
    runner.isFlippedHorizontally = true
    runner.xScale = -1.0
    if runner.state ~= "JUMPING" then
      physics.setVelocity(runner, WALKING_VELOCITY, 0)
      runner.state = "WALKING"
    end
    -- if vx < WALKING_VELOCITY and runner.state ~= "JUMPING" then
    --   physics.applyImpulse(runner, 0.05, 0)

    --   if runner.state ~= "WALKING" then
    --     -- switch to walk animation
    --   end

    --   runner.state = "WALKING"
    -- end
  end

  if leftButtonState == 1 then
    runner.isFlippedHorizontally = false
    runner.xScale = 1.0
    if runner.state ~= "JUMPING" then
      physics.setVelocity(runner, -WALKING_VELOCITY, 0)
      runner.state = "WALKING"
    end
    -- if vx > -WALKING_VELOCITY and runner.state ~= "JUMPING" then
    --   physics.applyImpulse(runner, -0.05, 0)
            
    --   if runner.state ~= "WALKING" then
    --             -- switch runner to walking animation
    --   end
        
    --   runner.state = "WALKING"
    -- end
        
  end

  if leftButtonState == 0 and rightButtonState == 0 and runner.state == "WALKING" then
    physics.setVelocity(runner, 0, 0)
    runner.state = "STANDING"
    -- set runner to standing image
  end
    
  if jumpButtonState == 1 then
    print "JUMP BUTTON PRESSED"
    if (runner.state ~= "JUMPING") then
      x,y = runner:getPosition()
      runner:setPosition(x, y + 20)
      physics.applyImpulse(runner, vx * 0.5, TERMINAL_VELOCITY)
      runner.state = "JUMPING"
    end
    
    jumpButtonState = 0
  end
      
  if runner.state == "JUMPING" then
    if vy > TERMINAL_VELOCITY then
      physics.setVelocity(runner, vx, TERMINAL_VELOCITY)
    end
    if vy < -TERMINAL_VELOCITY then
      physics.setVelocity(runner, vx, -TERMINAL_VELOCITY)
    end
  end
    
  if runner.state == "WALKING" then
    if vx > WALKING_VELOCITY then
      physics.setVelocity(runner, WALKING_VELOCITY, 0)
    end
    if vx < -WALKING_VELOCITY then
      physics.setVelocity(runner, -WALKING_VELOCITY, 0)
    end
  end

end


-- Called when scene is deallocated
function scene:destroyScene()


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. remove listeners, widgets, save state, etc.)

  -----------------------------------------------------------------------------

end

-- handle touch events
function scene:touchesBegan(evt)

  local touches = table.pack(evt:getTouches())
  
  for index, touch in ipairs(touches) do
    print("Lua: index = " .. index)
    local x = touch.x
    local y = touch.y

    if x > 284 then
      joystickStartX = x
              
    else
      jumpButtonState = 1
      print "JUMP!"
    end
  end

  return true
    
end

function scene:touchesMoved(evt)
  local touches = table.pack(evt:getTouches())
  for index, touch in ipairs(touches) do
    local x = touch.x
    local y = touch.y

    if x > 284 then
    
      if x < joystickStartX then
        leftButtonState = 1
        rightButtonState = 0
      end
                
      if x > joystickStartX then
          rightButtonState = 1
          leftButtonState = 0
      end
      joystickStartX = x
    end
          
  end

  return true

end

function scene:touchesEnded(evt)
  local touch = evt:getTouches()
  local x = touch.x
  local y = touch.y

  if x > 284 then
    rightButtonState = 0
    leftButtonState = 0
  else
    jumpButtonState = 0
  end
  
  return true

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene