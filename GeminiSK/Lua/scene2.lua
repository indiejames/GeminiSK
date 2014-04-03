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
local scene = director.newScene()


local zoomNode
local panNode
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
local myCurve

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
  print("Lua: Creating scene2")

  scene:setSize(1136,640)

  scene:setBackgroundImage("space2.jpg")

  
  zoomNode = node.newNode()
  scene:addChild(zoomNode)
  panNode = node.newNode()
  zoomNode:addChild(panNode)

  --shipSound = sound.newSound("rocket.wav")
  soundPlayer = sound.newAudioPlayer("rocket.wav")
  soundPlayer.numberOfLoops = -1
  soundPlayer:prepareToPlay()
  
  
  texture_atlas = texture.newTextureAtlas("8bit")
  texture1 = texture.newTexture(texture_atlas, "mario.01.png")
  
  --runner = sprite.newSprite("runner")
  runner = sprite.newSprite(texture1)
  runner.scale = 2
  runner.xScale = -1 * runner.xScale
  runner.name = "Mario"
  zoomNode:addChild(runner)
  runner:setPosition(0, 0)
  
  ship_texture_atlas = texture.newTextureAtlas("spaceship")
  ship_texture = texture.newTexture(ship_texture_atlas, "Spaceship.png")
  
  --runner = sprite.newSprite("runner")
  --runner = sprite.newSprite(texture1)
  
  ship = sprite.newSprite(ship_texture)
  ship.name = "Ship"

  zoomNode:addChild(ship)
  ship:setPosition(300,300)
  ship.scale = 0.3

  middleX = 600
  left = middleX + 500
  right = middleX + 500
  bottom = 100
  middleY = bottom + 200
  top = middleY + 200

  shipPath2 = path.newBezierPath(
      526.5, 304.5,
      930.5, 311.5, 704.5, 598.5, 911.27, 456.5,
      529.5, 298.5, 949.73, 166.5, 671.13, -10.36,
      173.5, 306.5, 387.87, 607.36, 191.86, 529.08,
      522.5, 294.5, 155.14, 83.92, 364.4, 56.15,
      true
    )
  
  --pbody = physics.newBodyFromCircle(30)
  --runner.physicsBody = pbody
  
 --sceneBody = physics.newBodyWidthEdgeLoopFromRect(0, 0, 1280, 960)
 --scene.physicsBody = sceneBody
  
  
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

 myPath = path.newBezierPath(0, 0, 200, 200, 0, 200, 200, 0)
  
  
 --circle.glowWidth = 2
 scene:setBackgroundColor(0,0,0)

  --ui.destroyLabel(label)
  --label = nil

  rotation = action.rotate(7.0, 3)
  -- pan = action.moveToX(300, 2.5)
  -- pan.timingMode = SKActionTimingEaseInEaseOut

  
  --rectangle = shape.newRectangle(200,100)
  -- rectangle:setFillColor(0,0.5,0)
  -- rectangle.zRotation = 1.5
  -- rectangle:setPosition(0, 300)
  
  -- panNode:addChild(circle)
  -- panNode:addChild(rectangle)
  
  --runner:addChild(rectangle)

  shipFollow = action.followPath(shipPath2, 8, false, true)

  shipFlame = emitter.newEmitter("ShipFlame", 0, 0)
  ship:addChild(shipFlame)
  shipFlame:setPosition(0, -200)
  shipFlame:setTarget(scene)
  --shipFlame:setScale(10)

  myCurve = shape.newCurve(shipPath2)
  zoomNode:addChild(myCurve)
  myCurve:setFillColor(0,0,0,0)
  myCurve:setStrokeColor(1,1,1,1)
  myCurve.lineWidth = 10

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

  -----------------------------------------------------------------------------
  
  print("Entering scene 2")

--sound.play(shipSound)

  
  soundPlayer:play(1.5)
  
  print("Lua: Adding label to scene")
 panNode:addChild(label)
 label.zzz = "A Test"
 print("Lua: zzz = " .. label.zzz)
 label.text = "New Text!!!"
  
  director.destroyScene("scene1")

  function doRotation()
    label2:runAction(rotation)
    label:runAction(rotation)
    circle:runAction(rotation)
  end

  --panNode:runAction(pan)
  
  rep = action.repeatAction(animate,-1)
  rotation = action.rotate(7.0, 3)
  followPath = action.followPath(myPath, 3, true, false)

  
  shipRep = action.repeatAction(shipFollow, -1)
  ship:runAction(shipRep)

  runner:runAction(rep)
  --runner:runAction(rotation)
  runner:runAction(followPath)

  function runner:touchesBegan (evt)
    print ("Runner touched")
    local touch = evt:getTouches()
    local x = touch.x
    local y = touch.y
    print ("(x, y) = (" .. x .. ", " .. y .. ")")
  end
    
  function goToscene3()
    nextSceneName = "scene3"
   director.gotoScene("scene_load_page", {transition_type = "flip", orientation = "vertical", duration=1.5})
  end

  timer.performWithDelay(20, goToscene3)


end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  
    --Runtime:removeEventListener("enterFrame", scene.starListener)
    rotation:delete()
    rotation = nil
    soundPlayer:stop()
    
    print("Exiting scene 2")

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

function scene:touchesBegan(evt)
    print "scene touched"
    local touch = evt:getTouches()
    local x = touch.x
    local y = touch.y
    print ("(x, y) = (" .. x .. ", " .. y .. ")")
  end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene