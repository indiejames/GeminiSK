//
//  LGeminiPath.h
//  GeminiSK
//
//  Created by James Norton on 11/15/13.
//
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_PATH_LUA_KEY "GeminiLib.GEMINI_PATH_LUA_KEY"

int luaopen_path_lib (lua_State *L);