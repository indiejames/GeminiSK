//
//  LGeminiDirector.h
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_CIRCLE_LUA_KEY "GeminiLib.GEMINI_CIRCLE_LUA_KEY"
#define GEMINI_RECTANGLE_LUA_KEY "GeminiLib.GEMINI_RECTANGLE_LUA_KEY"

int luaopen_shape_lib (lua_State *L);