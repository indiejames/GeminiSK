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
local scene = director.newScene()

local circles
local rotation

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
	print("Lua: Creating scene2")
    circles = {}
    for i=1,10 do
        circles[i] = shape.newCircle(20,100, 50 + i*25)
        circles[i].lineWidth = 1
        circles[i]:setStrokeColor(0,0,0.75)
        circles[i]:setFillColor(0.5,0,0.5)
        scene:addChild(circles[i])
    end
    
    rotation = action.rotate(7.0, 3)

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------
    
    print("Entering scene 1")
  
  function doRotation()
    for i=1,10 do
        circles[i]:runAction(rotation)
    end
  end

    timer.performWithDelay(1, doRotation)
    
 director.loadScene("scene1")
    
  function goToScene1()
    director.gotoScene("scene1")
  end

  timer.performWithDelay(5, goToScene1)

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

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene