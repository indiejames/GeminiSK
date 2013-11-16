//
//  GemObjectWrapper.h
//  GeminiSK
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define GEMINI_OBJECT_LUA_KEY "GeminiLib.GEMINI_OBJECT_LUA_KEY"

@class GemEvent;

@interface GemObjectWrapper : NSObject {
    NSMutableDictionary *eventHandlers;
}

@property (nonatomic) int selfRef;
@property (nonatomic) int propertyTableRef;
@property (nonatomic) int eventListenerTableRef;
@property lua_State *L;
@property (strong) NSString *name;
@property (weak) id delegate;

-(id)initWithLuaState:(lua_State *)luaState;
-(id) initWithLuaState:(lua_State *)luaState LuaKey:(const char *)luaKey;
-(BOOL)handleEvent:(GemEvent *)event;
//- (void)callLuaMethod:(NSStirng *)method withArgs:(NSString *)firstArg, ...;
@end
