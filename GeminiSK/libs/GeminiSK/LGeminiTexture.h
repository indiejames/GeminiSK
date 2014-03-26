//
//  LGeminiTexture.h
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#import "GemTexture.h"

GemTexture *getTextureAtIndex(lua_State *L, int index);
GemTexture *getTexture(lua_State *L);