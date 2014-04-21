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
local tiled = require("tile_reader")
local scene = director.newScene()
local map = tiled.loadMap(scene, "island_trio")
local boat
local startX
local startY



local zoomNode
local panNode


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene is first created.
-- Add scene elements here.
function scene:createScene( event )
  print("Lua: Creating scene2")

  scene:setSize(960,640)

  scene:setBackgroundImage("space2.jpg")
  
  texture_atlas = texture.newTextureAtlas("boats")
  boat_texture = texture.newTexture(texture_atlas, "ship_large_body.png")
  
  boat = sprite.newSprite(boat_texture)
  boat.scale =  0.25

  
  zoomNode = node.newNode()
  scene:addChild(zoomNode)
  panNode = node.newNode()
  zoomNode:addChild(panNode)
  
  scene:setBackgroundColor(0,0,0)

end


-- Called immediately after scene has moved onscreen:
function scene:didMoveToView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

  -----------------------------------------------------------------------------
  
  print("Entering scene 4")

  tiled.renderMap(panNode, map)
  panNode:addChild(boat)
  boat:setPosition(200, 500)
  boat.zRotation = 0.3
  panNode:setPosition(0,-256)


end


-- Called when scene is about to move offscreen:
function scene:willMoveFromView(  )


  -----------------------------------------------------------------------------

  --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  
   
    
    print("Exiting scene 4")

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
    --print "scene touched"
    local touch = evt:getTouches()
    local x = touch.x
    local y = touch.y
    --print ("(x, y) = (" .. x .. ", " .. y .. ")")
    startX = x
    startY = y
end

function scene:touchesMoved(evt)
    local touches = { evt:getTouches() }
    touch = touches[#touches]
    --print ("(x, y) = (" .. touch.x .. ", " .. touch.y .. ")")
    local deltaX = touch.x - startX
    local deltaY = touch.y - startY
    local nodeX, nodeY = panNode:getPosition()
    startX = touch.x
    startY = touch.y

    panNode:setPosition(nodeX + deltaX, nodeY + deltaY)
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


return scene