//
//  LGeminiNode.m
//  Gemini SK
//
//  Created by James Norton on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGeminiNode.h"
#import "LGeminiAction.h"
#import "LGeminiObject.h"
#import "Gemini.h"
#import "GemAction.h"

// Add a child node to the given node
int addChild(lua_State *L) {
    // stack: 1 - parent object, 2 - child object
    __unsafe_unretained GemObjectWrapper **parent = (__unsafe_unretained GemObjectWrapper **)lua_touserdata(L, 1);
    __unsafe_unretained GemObjectWrapper **child = (__unsafe_unretained GemObjectWrapper **)lua_touserdata(L, 2);
    
    SKNode *parentNode = (SKNode *)(*parent).delegate;
    SKNode *childNode = (SKNode *)(*child).delegate;
    
    // nodes can only be children of one parent (sad, really)
    if (childNode.parent) {
        [childNode removeFromParent];
    }
    
    [parentNode addChild:childNode];
    
    return 0;
}

// Remove child nodes from a parent node
int removeFromParent(lua_State *L){
    // stack: 1 - child object
   __unsafe_unretained GemObjectWrapper **child = (__unsafe_unretained GemObjectWrapper **)lua_touserdata(L, 1);
    
    SKNode *childNode = (SKNode *)(*child).delegate;
    
    [childNode removeFromParent];
    
    return 0;
}

static int newNode(lua_State *L){
    
    GemLog(@"Creating new node");
    
    SKNode *node = [[SKNode alloc] init];
    
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_NODE_LUA_KEY];
    luaData.delegate = node;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    node.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:node];
    
    return 1;
}



SKNode *getNodeAtIndex(lua_State *L, int index){
    // we don't check the userdata type here because it can be anything - we just force it to
    // GemObjectWrapper
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)lua_touserdata(L, index);
    return (SKNode *)(*go).delegate;
}

SKNode *getNode(lua_State *L){
    return getNodeAtIndex(L, 1);
}


int setPosition(lua_State *L) {
    // stack - 1 - object, 2 - x, 3 - y
    SKNode *node = getNode(L);
    
    GLfloat x = luaL_checknumber(L, 2);
    GLfloat y = luaL_checknumber(L, 3);
    
    CGPoint pos = CGPointMake(x, y);
    node.position = pos;
    
    return 0;
}

int destroyNode(lua_State *L){
    SKNode *node = getNode(L);
    
    if (node) {
        [node removeFromParent];
    }
    
    [[Gemini shared].geminiObjects removeObject:node];

    return 0;
}

int runAction(lua_State *L){
    SKNode *node = getNode(L);
    
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 2, GEMINI_ACTION_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    SKAction *skAction = gemAction.skAction;
    [node runAction:skAction completion:^{
        GemLog(@"Action complete");
        // allow the action wrapper to be GC'ed
        //[[Gemini shared].geminiObjects removeObject:gemAction];
    }];
    
    return 0;
}

// the mappings for the library functions
static const struct luaL_Reg nodeLib_f [] = {
    {"newNode", newNode},
    {"destroyNode", destroyNode},
    {NULL, NULL}
};

// mappings for the node methods
static const struct luaL_Reg node_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {"setPosition", setPosition},
    {"addChild", addChild},
    {"runAction", runAction},
    {NULL, NULL}
};

// the registration function
int luaopen_node_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // node
    createMetatable(L, GEMINI_NODE_LUA_KEY, node_m);
    
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, nodeLib_f);
    
    return 1;
}

