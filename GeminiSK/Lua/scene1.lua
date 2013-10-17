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
local physics = require("physics")
local texture = require("texture")
local scene = director.newScene()
scene:setSize(1280,960)

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

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
  print("Lua: Creating scene1")
  

  
  zoomNode = node.newNode()
  scene:addChild(zoomNode)
  panNode = node.newNode()
  zoomNode:addChild(panNode)
  
  
  texture_atlas = texture.newTextureAtlas("runner")
 texture1 = texture.newTexture(texture_atlas, "runner.0001.png")
  
  --runner = sprite.newSprite("runner")
 runner = sprite.newSprite(texture1)
  zoomNode:addChild(runner)
  runner:setPosition(150, 400)
  
  --pbody = physics.newBodyFromCircle(30)
  --runner.physicsBody = pbody
  
 --sceneBody = physics.newBodyWidthEdgeLoopFromRect(0, 0, 1280, 960)
 --scene.physicsBody = sceneBody
  
  scene:setPhysicsGravity(0,-4.5)
  
  frames =  {
  "runner.0001.png",
  "runner.0002.png",
  "runner.0003.png",
  "runner.0004.png",
  "runner.0005.png",
  "runner.0006.png",
  "runner.0007.png",
  "runner.0008.png",
  "runner.0009.png",
  "runner.0010.png"
  }
  
  --animate = action.animate("runner.0001.png",
  --"runner.0002.png",
 -- "runner.0003.png",
  --"runner.0004.png",
  --"runner.0005.png",
  --"runner.0006.png",
  --"runner.0007.png",
  --"runner.0008.png",
  --"runner.0009.png",
  --"runner.0010.png",
  --0.1)

  
  circle = shape.newCircle(50,200,200)
  circle.lineWidth = 1
  circle:setStrokeColor(0,0,0.75)
  circle:setFillColor(0.5,0,0.5)
 --circle.glowWidth = 2
 scene:setBackgroundColor(1.0,0,0)
 print("Lua: Adding label to scene")
 panNode:addChild(label)
 label.zzz = "A Test"
 print("Lua: zzz = " .. label.zzz)
  --ui.destroyLabel(label)
  --label = nil
  label2 = ui.newLabel("Chalkduster")
  label2.text = "Goodbye"
  label2:setPosition(200,300)
  panNode:addChild(label2)
  rotation = action.rotate(7.0, 3)
  -- pan = action.moveToX(300, 2.5)
  -- pan.timingMode = SKActionTimingEaseInEaseOut

  
  -- rectangle = shape.newRectangle(200,100)
  -- rectangle:setFillColor(0,0.5,0)
  -- rectangle.zRotation = 1.5
  -- rectangle:setPosition(0, 300)
  
  -- panNode:addChild(circle)
  -- panNode:addChild(rectangle)



end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

  -----------------------------------------------------------------------------
  
  print("Entering scene 1")

  function doRotation()
    label2:runAction(rotation)
    label:runAction(rotation)
    circle:runAction(rotation)
  end

  --panNode:runAction(pan)
  
--rep = action.repeatAction(animate,-1)

 --runner:runAction(rep)

  function goToScene2()
    director.gotoScene("scene2")
  end

  --timer.performWithDelay(1, doRotation)
  timer.performWithDelay(7, goToScene2)

  director.loadScene("scene2")

end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  
    --Runtime:removeEventListener("enterFrame", scene.starListener)
    rotation:delete()
    rotation = nil
    
    print("Exiting scene 1")

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