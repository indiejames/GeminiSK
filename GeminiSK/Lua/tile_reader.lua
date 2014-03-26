-- Read scenes from Tiled

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

local tiled = {}


function tiled.texture_for_tile(tile_id, tileset)
	index = tile_id - tileset.firstgid + 1
	tile = tileset.tiles[index]
	return tile.texture
end


function tiled.tileset_for_tile_id(id, map)
	tilesets = map.tilesets
	for i, tileset in ipairs(map.tilesets) do
		tiles = tileset.tiles
		if tileset.firstgid - 1 <= id and tileset.firstgid - 1 + #tiles >= id then
			return tileset
		end
	end

	return nil
end

function tiled.texCoordsForTile(tile_id, tileset)
	col_count = tileset.imagewidth / tileset.tilewidth
	row_count = tileset.imageheight / tileset.tileheight

	index = tile_id - tileset.firstgid

	print("tile_id = " .. tile_id .. " firstgid = " .. tileset.firstgid)

	col = index % col_count
	row = row_count - math.floor(index / col_count) - 1

	print ("index = " .. index .. " col = ".. col .. "  row = " .. row)

	x0 = col * (tileset.tilewidth / tileset.imagewidth)
	y0 = row * (tileset.tileheight / tileset.imageheight)
	x1 = x0 + tileset.tilewidth / tileset.imagewidth
	y1 = y0 + tileset.tileheight / tileset.imageheight

	return x0,y0,x1,y1

end

-- read a file and use it to set up a scene
function tiled.loadMap(scene, filename)
	map = require(filename)
	map.textures = {}

	for i, tileset in ipairs(map.tilesets) do
			print ("Lua: loading texture " .. tileset.image)
      tileset.texture = texture.newTexture(tileset.image)
      for j, tile in ipairs(tileset.tiles) do
      	x0, y0, x1, y1 = tiled.texCoordsForTile(j, tileset)
      	tile.texture = texture.newSubTexture(tileset.texture, x0, y0, x1, y1)
      end
  end

  return map

end

function tiled.renderMap(scene, map)

	for i, tile_id in ipairs(map.layers[1].data) do
		if tile_id ~= 0 then
			local tileset = tiled.tileset_for_tile_id(tile_id, map)
			local col = (i-1) % map.width
			local row = map.height - math.floor((i-1) / map.width) - 1
			local x = col * tileset.tilewidth + tileset.tilewidth / 2
			local y = row * tileset.tileheight + tileset.tileheight / 2

			local new_sprite = sprite.newSprite(tiled.texture_for_tile(tile_id, tileset))
			scene:addChild(new_sprite)
			new_sprite:setPosition(x, y)

		end
	end
	
end

return tiled


