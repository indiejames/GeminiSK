----------------------------------------------------------------------------------
--
-- scene_template.lua
--
----------------------------------------------------------------------------------

local director = require( "director" )
local ui = require("ui")
local action = require("action")
local timer = require("timer")
local physics = require("physics")
local shape = require("shape")
local scene = director.newScene()
scene:setSize(1136,640)

local mySound
local circles
local rotation

local wall_thickness = 10
local box_width = 100


function makeWalls()
  -- floor
  local floor = shape.newRectangle(1136, wall_thickness, 1136/2, wall_thickness/2)
  floor:setFillColor(0,1.0,0)
  floor.lineWidth = 0

  scene:addChild(floor)
  

  physics.addBody(floor)

  -- ceiling

  local ceiling = shape.newRectangle(1136, wall_thickness, 1136/2, 640 - wall_thickness/2)
  ceiling:setFillColor(0,1.0,0)
  ceiling.lineWidth = 0

  scene:addChild(ceiling)
  
physics.addBody(ceiling)


  -- left wall

  local left_wall = shape.newRectangle(wall_thickness, 640, wall_thickness/2, 320)
  left_wall:setFillColor(0,1.0,0)
  left_wall.lineWidth = 0

  scene:addChild(left_wall)
  
  physics.addBody(left_wall)

  -- right wall

  local right_wall = shape.newRectangle(wall_thickness, 640, 1136-wall_thickness/2, 320)
  right_wall:setFillColor(0,1.0,0)
  right_wall.lineWidth = 0

  scene:addChild(right_wall)
  
  physics.addBody(right_wall)


end


-- Called when the scene is first created.
-- Add scene elements here.



function scene:createScene( event )
	print("Lua: Creating scene2")

    
  physics.setGravity(0,-1.5)
    
    mySound = sound.newSound("wipe1.wav")

    circles = {}
    for i=1,10 do
        --circles[i] = shape.newCircle(20,100, 50 + i*25)

   circles[i] = shape.newRectangle(50, 20, 100, 50 + i*50)
        circles[i].lineWidth = 0
        circles[i]:setStrokeColor(0,0,0.75)
        circles[i]:setFillColor(0.5,0,0.5)
        scene:addChild(circles[i])
    end
    
    rotation = action.rotate(7.0, 13)

-- big_circle = shape.newCircle(20, 200, 200)
 --big_circle:setFillColor(0,1.0, 1.0)
 --big_circle.lineWidth = 0
 --scene:addChild(big_circle)
 --physics.addBody(big_circle, "dynamic", {restituiion=1, friction=0.5, density=10})
 
 --physics.applyForce(big_circle, 300,0)
  
  big_box = shape.newRectangle(box_width, box_width/2, 105, 205)
 big_box.name = "Big Box"
 big_box:setFillColor(1.0, 0, 0)
 scene:addChild(big_box)
 
 physics.addBody(big_box, "dynamic")

 -- big_box.zRotation = -0.77
 
 back_wheel = shape.newCircle(15, 70, 190)
 back_wheel:setFillColor(0,1.0, 1.0)
 scene:addChild(back_wheel)
 physics.addBody(back_wheel, "dynamic", {friction=1.0})
 physics.addJoint("revolute", big_box, back_wheel, 70, 190, {enableMotor=true, motorSpeed=-50,maxMotorTorque = 50})
 
 front_wheel = shape.newCircle(15, 140, 190)
 front_wheel:setFillColor(0,1.0, 1.0)
 scene:addChild(front_wheel)
 physics.addBody(front_wheel, "dynamic", {friction=0.5})
 physics.addJoint("revolute", big_box, front_wheel, 140, 190)
 
 ramp = shape.newPolygon(0,0, 200, 0, 200, 100)
 ramp:setFillColor(1,1,0)
 ramp:setPosition(500, 10)
 
 scene:addChild(ramp)

 physics.addBody(ramp, "static", {shape={0,0,200,0,200,100}})


  makeWalls()

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------
    
    print("Entering scene 1")
    
  scene:addChild(label)
  
  function doRotation()
    for i=1,10 do
        --circles[i]:runAction(rotation)
    end
  end

    timer.performWithDelay(1, doRotation)
    
 director.loadScene("scene1")
    
  function goToScene1()
    sound.play(mySound)
    director.gotoScene("scene1", {transition_type = "CIFilter", filter_name = "CISwipeTransition", filter_params={inputAngle = 1.57}, duration=0.75})
    --director.gotoScene("scene1", {transition_type = "CIFilter", filter_name = "CIFlashTransition", duration=1.5})

  end

 timer.performWithDelay(15, goToScene1)

  director.loadScene("scene1")

end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

	-----------------------------------------------------------------------------
    
    --Runtime:removeEventListener("enterFrame", scene.starListener)
    rotation:delete()
    rotation = nil
    
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
	print "scene2 destroyed"

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene