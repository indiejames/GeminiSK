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

#define GEMINI_LABEL_LUA_KEY "GeminiLib.GEMINI_LABEL_LUA_KEY"

int luaopen_ui_lib (lua_State *L);