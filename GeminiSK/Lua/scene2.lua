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
local myPath
local ship
local shipPath
local shipPath2
local shipSound
local soundPlayer
local myCurve
local textField

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

  soundPlayer = sound.newAudioPlayer("rocket.wav")
  soundPlayer.numberOfLoops = -1
  soundPlayer:prepareToPlay()
  
  ship_texture_atlas = texture.newTextureAtlas("spaceship")
  ship_texture = texture.newTexture(ship_texture_atlas, "Spaceship.png")
  
  ship = sprite.newSprite(ship_texture)
  ship.name = "Ship"

  zoomNode:addChild(ship)
  ship:setPosition(300,300)
  ship.scale = 0.3

  shipPath2 = path.newBezierPath(
      526.5, 304.5,
      930.5, 311.5, 704.5, 598.5, 911.27, 456.5,
      529.5, 298.5, 949.73, 166.5, 671.13, -10.36,
      173.5, 306.5, 387.87, 607.36, 191.86, 529.08,
      522.5, 294.5, 155.14, 83.92, 364.4, 56.15,
      true
  )

  scene:setBackgroundColor(0,0,0)

  shipFollow = action.followPath(shipPath2, 8, false, true)

  shipFlame = emitter.newEmitter("ShipFlame", 0, 0)
  ship:addChild(shipFlame)
  shipFlame:setPosition(0, -200)
  shipFlame:setTarget(scene)
  
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

  soundPlayer:play(1.5)
  
  textField = ui.newTextField(200,200, 300,150, "Superclarendon-Regular", 18)
  textField.text = "Super!"
  function textField:returnPressed()
    print(textField.text)
    return true
  end
  
  print("Lua: Adding label to scene")
  panNode:addChild(label)
  label.zzz = "A Test"
  print("Lua: zzz = " .. label.zzz)
  label.text = "New Text!!!"
  
  director.destroyScene("scene1")

  shipRep = action.repeatAction(shipFollow, -1)
  ship:runAction(shipRep)
    
end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  
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