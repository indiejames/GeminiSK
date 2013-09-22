//
//  LGeminiPhysics.m
//  GeminiSK
//
//  Created by James Norton on 9/3/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "GemPhysicsBody.h"
#import "LGeminiPhysics.h"
#import "LGeminiObject.h"
#import "Gemini.h"


static int newPhysicsBodyFromCircleWithRadius(lua_State *L){
    // stack: 1 - radius,

    CGFloat radius = luaL_checknumber(L, 1);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    GemPhysicsBody *gBody = [[GemPhysicsBody alloc] init];
    gBody.skPhysicsBody = body;
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_PHYSICS_BODY_LUA_KEY];
    luaData.delegate = gBody;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gBody.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:gBody];
    
    return 1;
}

static int newPhysicsBodyWithEdgeLoopFromRectangle(lua_State *L){
    // stack: x0, y0, width, height
    
    CGFloat x0 = luaL_checknumber(L, 1);
    CGFloat y0 = luaL_checknumber(L, 2);
    CGFloat width = luaL_checknumber(L, 3);
    CGFloat height = luaL_checknumber(L, 4);
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(x0, y0, width, height)];
    GemPhysicsBody *gBody = [[GemPhysicsBody alloc] init];
    gBody.skPhysicsBody = body;
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_PHYSICS_BODY_LUA_KEY];
    luaData.delegate = gBody;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gBody.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:gBody];
    
    return 1;
}


// the mappings for the library functions
static const struct luaL_Reg physicsLib_f [] = {
    {"newBodyFromCircle", newPhysicsBodyFromCircleWithRadius},
    {"newBodyWidthEdgeLoopFromRect", newPhysicsBodyWithEdgeLoopFromRectangle},
    {NULL, NULL}
};

// mappings for the sprite methods
static const struct luaL_Reg body_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    /*{"setPosition", setPosition},
    {"addChild", addChild},
    {"runAction", runAction},*/
    {NULL, NULL}
};

// the registration function
int luaopen_physics_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // physics body
    createMetatable(L, GEMINI_PHYSICS_BODY_LUA_KEY, body_m);
    
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, physicsLib_f);
    
    return 1;
}