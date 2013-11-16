//
//  LGeminiPath.m
//  GeminiSK
//
//  Created by James Norton on 11/15/13.
//
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "LGeminiPath.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"
#import "LGeminiNode.h"
#import "GemBezierPath.h"

#define VALUES_PER_POINT 2


static int newBezierPath(lua_State *L){
    // stack: x0, y0, x1, y1, a0x, a0y ... xn, yn, anx, any
    GemLog(@"Creating new bezier path");
    int numArgs = lua_gettop(L);
    
    int numPoints = numArgs / VALUES_PER_POINT;
    CGPoint *points = (CGPoint *)malloc(numPoints * sizeof(CGPoint));
    
    // should be 1 point to start plus three points per move (destination + 2 control points)
    
    int index = 1;
    for (int i=0; i<numPoints; i++) {
        float x = luaL_checknumber(L, index++);
        float y = luaL_checknumber(L, index++);
        points[i] = CGPointMake(x, y);
    }
    
    GemBezierPath *path = [[GemBezierPath alloc] initWithNum:numPoints Points:points];
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_PATH_LUA_KEY];
    luaData.delegate = path;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    /*shape.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:shape];*/
    
    return 1;
}


// the mappings for the library functions
static const struct luaL_Reg pathLib_f [] = {
    {"newBezierPath", newBezierPath},
    {NULL, NULL}
};

// mappings for the bezier_path methods
static const struct luaL_Reg bezier_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {NULL, NULL}
};


// the registration function
int luaopen_path_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // bezier path
    createMetatable(L, GEMINI_PATH_LUA_KEY, bezier_m);
    
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, pathLib_f);
    
    return 1;
}