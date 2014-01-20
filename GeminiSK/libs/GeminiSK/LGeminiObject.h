//
//  LGeminiObject.h
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

int addEventListener(lua_State *L); // used everywhere
int removeEventListener(lua_State *L);
int luaopen_geminiObjectLib (lua_State *L);
int genericIndex(lua_State *L);
int genericNewIndex(lua_State *L);
int genericGC(lua_State *L);
int genericDestroy(lua_State *L);