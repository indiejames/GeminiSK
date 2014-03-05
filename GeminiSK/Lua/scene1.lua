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


local mySound
local boxes
local spinner1
local spinner2
local rotation

local wall_thickness = 10
local car_with = 100
local box_height = 50
local box_width = box_height / 2
local box_spacing = box_width + 2
local box_bottom_row_start = 900
local box_middle_row_start = box_bottom_row_start + 0.6 * box_width
local box_top_row_start = box_middle_row_start + 0.6 * box_width
local box_bottom_row_y = box_height / 2 + wall_thickness
local box_middle_row_y = box_bottom_row_y + box_height + 2
local box_top_row_y = box_middle_row_y + box_height + 2

local box_positions = {
  box_bottom_row_start, box_bottom_row_y, box_bottom_row_start + box_spacing, box_bottom_row_y, box_bottom_row_start + 2 * box_spacing, box_bottom_row_y,
  box_middle_row_start, box_middle_row_y, box_middle_row_start + box_spacing, box_middle_row_y,
  box_top_row_start, box_top_row_y
}


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

function makeBoxes()
  boxes = {}
  for i=1,6 do
      local x = box_positions[i*2 - 1]
      local y = box_positions[i*2]
      boxes[i] = shape.newRectangle(box_width, box_height, x, y)
      boxes[i]:setFillColor(0.5,0,0.5)
      scene:addChild(boxes[i])
      physics.addBody(boxes[i], "dynamic")
  end
end

function makeCar()
  big_box = shape.newRectangle(car_with, car_with/2, 105, 205)
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
end

function makeRamp()
  ramp = shape.newPolygon(0,0, 200,0, 200,100, 0,0)
  ramp:setFillColor(1,1,0)
  ramp:setPosition(500, 10)
   
  scene:addChild(ramp)

  physics.addBody(ramp, "static", {shape={0,0,200,0,200,100,0,0}})
end

-- Called when the scene is first created.
-- Add scene elements here.

function makeSpinners()
  spinner1 = shape.newRectangle(100, 100, 500, 400)
  spinner1:setFillColor(1,0,1)
  scene:addChild(spinner1)

  spinner2 = shape.newRectangle(50, 50, 750, 500)
  spinner2:setFillColor(0,1,0)
  scene:addChild(spinner2)
end



function scene:createScene( event )
	print("Lua: Creating scene2")

  scene:setSize(1136,640)

  physics.setGravity(0,-1.5)
  physics.setDebug(true)
  physics.setSimulationSpeed(0.01)
    
  mySound = sound.newSound("wipe1.wav")
    
  rotation = action.rotate(7.0, 13)
  rotation2 = action.rotate(-6.28, 3)
  rep1 = action.repeatAction(rotation, -1)
  rep2 = action.repeatAction(rotation2, -1)


  makeWalls()

  makeRamp()

  makeBoxes()

  makeCar()

  makeSpinners()

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------
    
  print("Entering scene 1")
    
  scene:addChild(label)

  spinner1:runAction(rep1)
  spinner2:runAction(rep2)
    
  director.loadScene("scene2")
    
  function goToscene2()
    --sound.play(mySound)
    --director.gotoScene("scene2", {transition_type = "CIFilter", filter_name = "CISwipeTransition", filter_params={inputAngle = 1.57}, duration=0.75})
    director.gotoScene("scene2", {transition_type = "push", direction = "up", duration=1.5})

  end

  timer.performWithDelay(15, goToscene2)


end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

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
	print "scene1 destroyed"

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene