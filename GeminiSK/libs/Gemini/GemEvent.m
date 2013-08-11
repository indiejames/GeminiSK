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
@synthesize luaData;
@synthesize target;
@synthesize timestamp;
@synthesize name;

-(id) initWithTarget:(GemObject *)trgt {
    self = [super init];
    if (self) {
        self.target = trgt;
    }
    
    return self;
}

-(id) initWithLuaState:(lua_State *)luaState Target:(GemObject *)trgt LuaKey:(const char *)luaKey {
    self = [super init];
    
    if (self) {
        luaData = [[GemObject alloc] initWithLuaState:luaState LuaKey:luaKey];
        luaData.delegate = self;
        target = trgt;
    }
    
    // empty the stack
    lua_pop(luaState, lua_gettop(luaState));
    
    return self;
}

-(id)initWithLuaState:(lua_State *)luaState Target:(GemObject *)trgt {
    self = [super init];
    
    if (self) {
        luaData = [[GemObject alloc] initWithLuaState:luaState];
        luaData.delegate = self;
        target = trgt;
    }
    
    // empty the stack
    lua_pop(luaState, lua_gettop(luaState));
    
    return self;

}

/*
-(id)initWithLuaState:(lua_State *)luaState Target:(GemObject *)trgt Event:(UIEvent *)evt; {
    self = [super initWithLuaState:luaState LuaKey:GEMINI_EVENT_LUA_KEY];
    if (self) {
        target = trgt;
        if (evt) {
            timestamp = [NSNumber numberWithDouble:evt.timestamp];
        }
        
    }
    
    return self;
}*/

@end
