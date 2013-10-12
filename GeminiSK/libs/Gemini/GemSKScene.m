//
//  GemSKScene.m
//  GeminiSK
//
//  Created by James Norton on 8/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "Gemini.h"
#import "GemSKScene.h"
#import "GemObject.h"
#import "GemSKSpriteNode.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

@implementation GemSKScene

// TODO - add code to delegate life events to Lua code

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _textureAtlases = [NSMutableArray arrayWithCapacity:1];
        
        // The scene should be initialized with Lua code in the createScene() method
    }
    return self;
}

-(void)callMethodOnScene:(NSString *)methodStr {
    
    const char *method = [methodStr cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    GemObject *luaData = [self.userData objectForKey:@"LUA_DATA"];
    lua_State *L = luaData.L;
    
    // get the top of the stack so we can clear the items we've added when we are done
    int top = lua_gettop(L);
    
    // push our attached Lua object's userdata onto the stack
    lua_rawgeti(L, LUA_REGISTRYINDEX, luaData.propertyTableRef);
    
    // retrieve our method from the property table
    lua_getfield(L, -1, method);
    
    if (lua_isfunction(L, -1)) {
        //GemLog(@"Event handler is a function");
        // load the stacktrace printer for our error function
        int base = lua_gettop(L);  // function index
        lua_pushcfunction(L, traceback);  // push traceback function for error handling
        lua_insert(L, base);
        
        // make this object the first argument to the function
        lua_rawgeti(L, LUA_REGISTRYINDEX, luaData.selfRef);
        
        // call our method
        int err = lua_pcall(L, 1, LUA_MULTRET, -3);
        if (err != 0) {
            const char *msg = lua_tostring(L, -1);
            NSLog(@"Error executing method: %s", msg);
        }
    }
    
    lua_pop(L, lua_gettop(L) - top);
    
}

-(void)didMoveToView:(SKView *)view {
    GemLog(@"Scene %@ moved to view", self.name);
    [self callMethodOnScene:@"didMoveToView"];
}

-(void)update:(NSTimeInterval)currentTime {
    [[Gemini shared].timerManager update:currentTime];
    [[Gemini shared].director doPendingSceneTransition];
    
    GemObject *luaData = [self.userData objectForKey:@"LUA_DATA"];
    lua_State *L = luaData.L;
    lua_gc(L, LUA_GCSTEP, 1);
}

-(void)willMoveFromView:(SKView *)view {
    [self callMethodOnScene:@"willMoveFromView"];
}

-(void)didSimulatePhysics {
    [self callMethodOnScene:@"didSimulatePhysics"];
}

-(void)didEvaluateActions {
    [self callMethodOnScene:@"didEvaluateActions"];
}

-(void)didChangeSize:(CGSize)oldSize {
    //[self callMethodOnScene:@"didChangeSize"];
}

-(BOOL)isReady {
    BOOL ready = YES;
    unsigned int childCount = [self.children count];
    for (int i=0; i<childCount; i++) {
        id child = [self.children objectAtIndex:i];
        if ([child isKindOfClass:[GemSKSpriteNode class]]) {
            if (!((GemSKSpriteNode *)child).isLoaded) {
                ready = NO;
            }
        }
    }
    
    return ready;
}

@end
