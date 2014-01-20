//
//  LGeminiAction.h
//  GeminiSK
//
//  Created by James Norton on 8/15/13.
//
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_ACTION_LUA_KEY "GeminiLib.GEMINI_ACTION_LUA_KEY"

int luaopen_action_lib (lua_State *L);