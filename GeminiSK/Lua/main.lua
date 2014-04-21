--
-- This is sample code.  Change this for your application.
--

gemini = require('gemini')
--display = require('display')
--physics = require('physics')
local director = require('director')

print("Lua: using main")

-- Handler for application state change events,
-- Add code here to save/load game state.
function exitHandler(event)
    print ("Lua: Got '" .. event.name .. "' event")
    
end

Runtime:addEventListener("applicationWillExit", exitHandler)
Runtime:addEventListener("applicationWillResignActive",exitHandler)
Runtime:addEventListener("applicationDidEnterBackground", exitHandler)
Runtime:addEventListener("applicationWillEnterForeground", exitHandler)

-- A global label that can be added to any scene
label = ui.newLabel("Superclarendon-Regular")
label.fontSize = 30
label.text = "SCORE: 1,000,000"
print("Lua: setting label position")
label:setPosition(640,600)
--label.zRotation = 1.5

-- next scene - used by scene loader
nextSceneName = "scene4"
director.loadScene("scene_load_page")
director.gotoScene("scene_load_page", {synchronous = "true"})

--director.loadScene("scene2")
--director.gotoScene("scene2", {synchronous = "true"})