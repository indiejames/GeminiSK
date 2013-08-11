//
//  GemNode.m
//  GeminiSK
//
//  Created by James Norton on 8/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemNode.h"

@implementation GemNode

-(id)initWithLuaState:(lua_State *)luaState {
    self = [super initWithLuaState:luaState LuaKey:GEM_NODE_KEY];
    
    // skNode must be initialized by child classes
    
    return self;
}

-(id)initWithLuaState:(lua_State *)luaState LuaKey:(const char *)luaKey {
    self = [super initWithLuaState:luaState LuaKey:luaKey];
    
    // skNode must be initialized by child classes
    
    return self;

}

// TODO add methods to proxy tranformations, etc.

@end
