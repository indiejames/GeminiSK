----------------------------------------------------------------------------------
--
-- scene_template.lua
--
----------------------------------------------------------------------------------

local director = require( "director" )
local ui = require("ui")
local scene = director.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of functions (below) will only be executed once,
--	unless director.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
	print("Lua: Creating scene1")
    scene:setBackgroundColor(1.0,0,0)
   print("Lua: Adding label to scene")
  scene:addChild(label)
  label.zzz = "A Test"
  print("Lua: zzz = " .. label.zzz)
  --ui.destroyLabel(label)
  --label = nil
  local label2 = ui.newLabel("Chalkduster")
  label2.text = "Goodbye"
  label2:setPosition(200,300)
  scene:addChild(label2)
end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------
    
    print("Entering scene 1")
    

end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

	-----------------------------------------------------------------------------
    
    --Runtime:removeEventListener("enterFrame", scene.starListener)
    
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
    
    --  It is not recommended to use this  --
    --  method for animation - use physics --
    --  and actions instead.               --
    
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