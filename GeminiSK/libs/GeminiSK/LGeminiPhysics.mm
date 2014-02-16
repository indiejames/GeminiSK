//
//  LGeminiPhysics.m
//  GeminiSK
//
//  Created by James Norton on 9/3/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "GemPhysics.h"
#import "GemPhysicsBody.h"
#import "LGeminiPhysics.h"
#import "LGeminiLuaSupport.h"
extern "C" {
#import "LGeminiNode.h"
}
#import "LGeminiObject.h"
#import "Gemini.h"
#include "Box2D.h"

static int setGravity(lua_State *L){
    GemSKScene *scene = [Gemini shared].director.activeScene;
    float gx = lua_tonumber(L, 1);
    float gy = lua_tonumber(L, 2);
    [scene.physics setGravityGx:gx Gy:gy];
    
    return 0;
}

static int addBody(lua_State *L){
    SKNode *node = getNode(L);
    
    GemLog(@"Adding physics to %@", node.name);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableDictionary *fixtureDefs = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:fixtureDefs forKey:@"fixtures"];
    
    NSString *type = @"static";
    
    int numArgs = lua_gettop(L);
    
    for (int i=1; i<numArgs; i++) {
        if (lua_isstring(L, i+1)) {
            // type attribute
            type = [NSString stringWithUTF8String:lua_tostring(L, i+1)];
            
        } else {
            // argument is a table - iterate over keys/vals to add to configuration for fixtures
            
            NSMutableDictionary *fixtureDef = [[NSMutableDictionary alloc] initWithCapacity:1];
            NSString *fixtureId = @"ANONYMOUS";
            
            lua_pushnil(L);  /* first key */
            while (lua_next(L, i+1) != 0) {
                // 'key' (at index -2) and 'value' (at index -1)
                
                const char *key = lua_tostring(L, -2);
                if (strcmp(key, "shape") == 0) {
                    // value is a table
                    
                    NSMutableArray *shape = [NSMutableArray arrayWithCapacity:1];
                    NSMutableArray *tmpShape = [NSMutableArray arrayWithCapacity:1];
                    [fixtureDef setObject:shape forKey:[NSString stringWithUTF8String:key]];
                    
                    // iterate over the table and copy its values
                    lua_pushnil(L);
                    while (lua_next(L, -2) != 0) {
                        double value = lua_tonumber(L, -1);
                        [tmpShape addObject:[NSNumber numberWithDouble:value]];
                        // removes 'value'; keeps 'key' for next iteration
                        lua_pop(L, 1);
                    }
                    
                    // reverse the order to compensate for difference with Corona
                    for (int i=[tmpShape count]/2 - 1; i>=0; i--) {
                        NSNumber *x = [tmpShape objectAtIndex:i*2];
                        NSNumber *y = [tmpShape objectAtIndex:i*2+1];
                        [shape addObject:x];
                        [shape addObject:y];
                    }
                    
                } else if (strcmp(key, "filter") == 0){
                    // value is a table
                    NSMutableDictionary *filter = [NSMutableDictionary dictionaryWithCapacity:3];
                    [fixtureDef setObject:filter forKey:@"filter"];
                    // iterate over table keys/values
                    lua_pushnil(L);
                    while (lua_next(L, -2) != 0) {
                        const char *filterKey = lua_tostring(L, -2);
                        unsigned int value = lua_tounsigned(L, -1);
                        [filter setObject:[NSNumber numberWithUnsignedInt:value] forKey:[NSString stringWithUTF8String:filterKey]];
                        // remove the value but leave the key for the next iteration
                        lua_pop(L, 1);
                    }
                } else if (strcmp(key, "pe_fixture_id") == 0){
                    const char *fixId = lua_tostring(L, -1);
                    fixtureId = [NSString stringWithUTF8String:fixId];
                } else if (strcmp(key, "position") == 0) {
                    // value is a table
                    
                    NSMutableArray *position = [NSMutableArray arrayWithCapacity:2];
                    [fixtureDef setObject:position forKey:[NSString stringWithUTF8String:key]];
                    
                    // iterate over the table and copy its values
                    lua_pushnil(L);
                    while (lua_next(L, -2) != 0) {
                        double value = lua_tonumber(L, -1);
                        [position addObject:[NSNumber numberWithDouble:value]];
                        // removes 'value'; keeps 'key' for next iteration
                        lua_pop(L, 1);
                    }
                } else if (strcmp(key, "isSensor") == 0){
                    bool isSensor = lua_toboolean(L, -1);
                    [fixtureDef setObject:[NSNumber numberWithBool:isSensor] forKey:@"isSensor"];
                } else {
                    // handle float values like density, friction, etc.
                    double val = lua_tonumber(L, -1);
                    
                    [fixtureDef setObject:[NSNumber numberWithDouble:val] forKey:[NSString stringWithUTF8String:key]];
                    
                }
                
                // removes 'value'; keeps 'key' for next iteration
                lua_pop(L, 1);
            }
            
            [fixtureDefs setObject:fixtureDef forKey:fixtureId];
        }
        
    }
    
    [params setObject:type forKey:@"type"];
    
    GemSKScene *scene = [Gemini shared].director.activeScene;
    
    [scene.physics addBodyToNode:node WithParams:params];
    
    
    return 0;
}

int applyForce(lua_State *L){
    GemSKScene *scene = [Gemini shared].director.activeScene;
    double scale = [scene.physics getScale];
    SKNode *node = getNode(L);
    
    float fx = luaL_checknumber(L, 2);
    float fy = luaL_checknumber(L, 3);
    
    GemPhysicsBody *gBody = [node.userData objectForKey:[NSString stringWithFormat:@"%s", GEMINI_PHYSICS_BODY_LUA_KEY]];
    
    b2Body *body = (b2Body *)gBody.body;
    
    if (body == NULL) {
        lua_pushstring(L, "LUA ERROR: Object does not have a physics body attached");
        lua_error(L);
    } else {
        // use the coordinates for the point of application if they have been supplied
        if (lua_gettop(L) == 5) {
            float x = luaL_checknumber(L, 4) / scale;
            float y = luaL_checknumber(L, 5) / scale;
            body->ApplyForce(b2Vec2(fx,fy), b2Vec2(x,y), true);
        } else {
            body->ApplyForceToCenter(b2Vec2(fx,fy), true);
        }
        
    }
    
    return 0;
}


/*static int newPhysicsBodyFromCircleWithRadius(lua_State *L){
    // stack: 1 - radius,

    CGFloat radius = luaL_checknumber(L, 1);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    GemPhysicsBody *gBody = [[GemPhysicsBody alloc] init];
    gBody.skPhysicsBody = body;
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_PHYSICS_BODY_LUA_KEY];
    luaData.delegate = gBody;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gBody.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:gBody];
    
    return 1;
}*/

static int newPhysicsBodyWithEdgeLoopFromRectangle(lua_State *L){
    // stack: x0, y0, width, height
    
    /*CGFloat x0 = luaL_checknumber(L, 1);
    CGFloat y0 = luaL_checknumber(L, 2);
    CGFloat width = luaL_checknumber(L, 3);
    CGFloat height = luaL_checknumber(L, 4);
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(x0, y0, width, height)];
    GemPhysicsBody *gBody = [[GemPhysicsBody alloc] init];
    gBody.skPhysicsBody = body;
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_PHYSICS_BODY_LUA_KEY];
    luaData.delegate = gBody;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gBody.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:gBody];*/
    
    return 1;
}


// the mappings for the library functions
static const struct luaL_Reg physicsLib_f [] = {
    {"addBody", addBody},
    {"applyForce", applyForce},
    {"setGravity", setGravity},
    {NULL, NULL}
};

// mappings for the physics body methods
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
extern "C" int luaopen_physics_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // physics body
    createMetatable(L, GEMINI_PHYSICS_BODY_LUA_KEY, body_m);
    
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, physicsLib_f);
    
    return 1;
}