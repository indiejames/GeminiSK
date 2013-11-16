//
//  LGeminiLuaSupport.h
//  Gemini
//
//  Created by James Norton on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifdef __cplusplus
extern "C" {
#endif

#import <SpriteKit/SpriteKit.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#import "GemObjectWrapper.h"
//#import "GemDisplayObject.h"
//#import "GemDisplayGroup.h"

//void callLuaMethodForDisplayObject(lua_State *L, int methodRef, GemDisplayObject *obj);
void createMetatable(lua_State *L, const char *key, const struct luaL_Reg *funcs);
int genericNodeIndex(lua_State *L, SKNode *obj);
int genericNodeNewIndex(lua_State *L, SKNode *obj);
int addChild(lua_State *L);
//int genericGeminiDisplayObjectIndex(lua_State *L, GemDisplayObject *obj);
//int genericGemDisplayGroupIndex(lua_State *L, GemDisplayGroup *obj);
//int genericGemDisplayObjecNewIndex(lua_State *L, GemDisplayObject __unsafe_unretained **obj);
int removeSelf(lua_State *L);
int genericDelete(lua_State *L);
int isObjectTouching(lua_State *L);
void setDefaultValues(lua_State *L);
void setupObject(lua_State *L, const char *luaKey, GemObjectWrapper *obj);
NSDictionary *tableToDictionary(lua_State *L, int stackIndex);

void lockLuaLock();
void unlockLuaLock();

#ifdef __cplusplus
}
#endif