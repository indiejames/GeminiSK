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


void createMetatable(lua_State *L, const char *key, const struct luaL_Reg *funcs);
int genericNodeIndex(lua_State *L, SKNode *obj);
int genericNodeNewIndex(lua_State *L, SKNode *obj);
int addChild(lua_State *L);
int removeSelf(lua_State *L);
int genericDelete(lua_State *L);
int isObjectTouching(lua_State *L);
void setDefaultValues(lua_State *L);
void setupObject(lua_State *L, const char *luaKey, GemObjectWrapper *obj);
NSDictionary *tableToDictionary(lua_State *L, int stackIndex);
GemObjectWrapper *createObjectWrapper(lua_State *L, const char *objectType, id object);
void saveObjectReference(id object);
void createObjectAndSaveRef(lua_State *L, const char *objectType, id object);
NSDictionary *getTableFromStack(lua_State *L, int index);
void lockLuaLock();
void unlockLuaLock();

#ifdef __cplusplus
}
#endif