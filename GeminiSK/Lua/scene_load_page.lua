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

local progressBarBackground
local progressBar
local sceneToLoad
local done

function scene:createScene( event )
	print("Lua: Creating scene loader")
	scene:setSize(1136,640)
	scene:setBackgroundColor(0.7,0,0.7)

	progressBarBackground = shape.newRectangle(500, 70, 568,320)
	progressBarBackground:setFillColor(0,0,0.7)
	progressBarBackground.setLineWidth = 0
	scene:addChild(progressBarBackground)
	progressBar = shape.newRectangle(490, 60)
	progressBar:setFillColor(1,1,1)
	progressBarBackground:addChild(progressBar)

end

function scene:didMoveToView()
	print ("Lua: scene scene_load_page.lua moved to view")
	progressBar.xScale = 0
	print ("Lua: loading scene " .. nextSceneName)
	sceneToLoad = director.loadScene(nextSceneName)
	done = false

end

function scene:willMoveFromView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  
    --Runtime:removeEventListener("enterFrame", scene.starListener)
   
    
    print("Lua: Exiting scene loader")

  end

-- Called when the scene physics have been simulated
function scene:didSimulatePhysics()

end

-- Called when scenes actions have been updated
function scene:didEvaluateActions()

	print ("scene_load_page didEvaluateActions")
	progress = sceneToLoad.percentLoaded / 100.0
	print ("Lua: load progres: " .. progress * 100)

 	progressBar.xScale = progress

	-- if not done then

	if progress == 1 and not done then
			
	 		print ("Lua: Time to load scene " .. nextSceneName)

	 		done = true
	 
	 		director.gotoScene(nextSceneName, {transition_type = "flip", orientation = "horizontal", pauses_outgoing_scene = true, duration=1.5})

 	end
    
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