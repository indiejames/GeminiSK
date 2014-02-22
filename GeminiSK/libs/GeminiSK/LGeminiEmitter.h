//
//  LGeminiEmitter.h
//  GeminiSK
//
//  Created by James Norton on 2/21/2014.
//
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_EMITTER_LUA_KEY "GeminiLib.GEMINI_CIRCLE_LUA_KEY"

int luaopen_emitter_lib (lua_State *L);