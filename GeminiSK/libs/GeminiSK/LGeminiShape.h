//
//  LGeminiShape.h
//  GeminiSK
//
//  Created by James Norton on 10/12/2013.
//
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_CIRCLE_LUA_KEY "GeminiLib.GEMINI_CIRCLE_LUA_KEY"
#define GEMINI_RECTANGLE_LUA_KEY "GeminiLib.GEMINI_RECTANGLE_LUA_KEY"
#define GEMINI_POLYGON_LUA_KEY "GeminiLib.GEMINI_POLYGON_LUA_KEY"
#define GEMINI_CURVE_LUA_KEY "GeminiLib.GEMINI_CURVE_LUA_KEY"

int luaopen_shape_lib (lua_State *L);