//
//  LGeminiSound.h
//  GeminiSK
//
//  Created by James Norton on 12/20/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_SOUND_LUA_KEY "GeminiLib.GEMINI_SOUND_LUA_KEY"

int luaopen_soundlib (lua_State *L);