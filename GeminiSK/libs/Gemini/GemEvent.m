//
//  GeminiEvent.m
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GemEvent.h"
#import "LGeminiEvent.h"

@implementation GemEvent
@synthesize target;
@synthesize timestamp;
@synthesize name;

-(id) initWithTarget:(GemObjectWrapper *)trgt {
    self = [super init];
    if (self) {
        self.target = trgt;
    }
    
    return self;
}

-(id) initWithLuaState:(lua_State *)luaState Target:(GemObjectWrapper *)trgt LuaKey:(const char *)luaKey {
    self = [super init];
    
    if (self) {
        GemObjectWrapper *obj = [[GemObjectWrapper alloc] initWithLuaState:luaState LuaKey:luaKey];
        obj.delegate = self;
        NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
        [wrapper setObject:obj forKey:@"LUA_DATA"];
        self.userData = wrapper;
        target = trgt;
    }
    
    // empty the stack
    lua_pop(luaState, lua_gettop(luaState));
    
    return self;
}

-(id)initWithLuaState:(lua_State *)luaState Target:(GemObjectWrapper *)trgt {
    self = [super init];
    
    if (self) {
        GemObjectWrapper *obj = [[GemObjectWrapper alloc] initWithLuaState:luaState LuaKey:GEMINI_EVENT_LUA_KEY];
        obj.delegate = self;
        NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
        [wrapper setObject:obj forKey:@"LUA_DATA"];
        self.userData = wrapper;
        target = trgt;
    }
    
    // empty the stack
    lua_pop(luaState, lua_gettop(luaState));
    
    return self;

}

@end
