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
--	Code outside of listener functions (below) will only be executed once,
--	unless director.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("Lua: Creating scene1")
    scene:setBackgroundColor(1.0,0,0)
  label = ui.newLabel("Chalkduster")
 label.fontSize = 30
  label.text = "Hello, James!"
 print("Lua: setting label position")
  label:setPosition(200,100)
  label.zRotation = 1.5
 print("Lua: Adding label to scene")
  scene:addChild(label)
  label.zzz = "A Test"
  print("Lua: zzz = " .. label.zzz)

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView( event )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------
    
    print("Entering scene 1")
    

end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView( event )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

	-----------------------------------------------------------------------------
    
    --Runtime:removeEventListener("enterFrame", scene.starListener)
    
    print("Exiting scene 1")

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene.name = "scene1"

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "didMoveToView" event is dispatched whenever scene transition has finished
scene:addEventListener( "didMoveToView", scene )

-- "willMoveFromView" event is dispatched before next scene's transition begins
scene:addEventListener( "willMoveFromView", scene )

-- "destroyScene" event is dispatched before view is deallocated
scene:addEventListener( "destroyScene", scene )

return scene