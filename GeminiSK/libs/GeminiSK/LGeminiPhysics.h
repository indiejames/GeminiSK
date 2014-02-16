//
//  LGeminiPhysics.h
//  GeminiSK
//
//  Created by James Norton on 9/3/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//



#define GEMINI_PHYSICS_WORLD_LUA_KEY "GeminiLib.GEMINI_PHYSICS_WORLD_LUA_KEY"

#define RENDER_PADDING (0.0)

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
#import "LGeminiLuaSupport.h"
#import "LGeminiObject.h"
    
//    
//    int applyForce(lua_State *L);
//    int applyLinearImpulse(lua_State *L);
//    int setLinearVelocity(lua_State *L);
    
#ifdef __cplusplus
}
#endif