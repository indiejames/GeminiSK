//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "LGeminiShape.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"
#import "LGeminiNode.h"

extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);

static int newCircle(lua_State *L){
    // stack: 1 - radius, 2 - x (optional), 3 - y (optional)
    
    GemLog(@"Creating new circle");
    float radius = luaL_checknumber(L, 1);
    
    float x = -radius;
    float y = -radius;
    
    if (lua_gettop(L) > 1) {
        x = luaL_checknumber(L, 2);
    }
    
    if (lua_gettop(L) > 2) {
        y = luaL_checknumber(L, 3);
    }
    
    
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(x, y, radius * 2.0, radius * 2.0), NULL);
    SKShapeNode *shape = [[SKShapeNode alloc] init];
    shape.path = path;
    createObjectAndSaveRef(L, GEMINI_CIRCLE_LUA_KEY, shape);
    
    [[Gemini shared].geminiObjects addObject:shape];
    
    return 1;
}

static int newRectangle(lua_State *L){
    // stack: 1 - width, 2 - height
    
    GemLog(@"Creating new rectangle");
    float width = luaL_checknumber(L, 1);
    float height = luaL_checknumber(L, 2);
    
    float x = -width/2.0;
    float y = -height/2.0;
    
    if (lua_gettop(L) > 2) {
        x = luaL_checknumber(L, 2);
    }
    
    if (lua_gettop(L) > 3) {
        y = luaL_checknumber(L, 3);
    }
    
    CGPathRef path = CGPathCreateWithRect(CGRectMake(x, y, width, height), NULL);
    SKShapeNode *shape = [[SKShapeNode alloc] init];
    shape.path = path;
    
    createObjectAndSaveRef(L, GEMINI_RECTANGLE_LUA_KEY, shape);
    
    
    return 1;
}

// set the color of lines used to draw a shape
static int setStrokeColor(lua_State *L){
    SKShapeNode *shapeNode = (SKShapeNode *)getNode(L);
    float red = luaL_checknumber(L, 2);
    float green = luaL_checknumber(L, 3);
    float blue = luaL_checknumber(L, 4);
    float alpha = 1.0;
    if (lua_gettop(L) == 5) {
        alpha = luaL_checknumber(L, 5);
    }
    
    shapeNode.strokeColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
    
    return 0;
}

// set the color used to fill a shape (default is no fill)
static int setFillColor(lua_State *L){
    SKShapeNode *shapeNode = (SKShapeNode *)getNode(L);
    float red = luaL_checknumber(L, 2);
    float green = luaL_checknumber(L, 3);
    float blue = luaL_checknumber(L, 4);
    float alpha = 1.0;
    if (lua_gettop(L) == 5) {
        alpha = luaL_checknumber(L, 5);
    }
    
    shapeNode.fillColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
    
    return 0;
}

// the mappings for the library functions
static const struct luaL_Reg shapeLib_f [] = {
    {"newCircle", newCircle},
    {"newRectangle", newRectangle},
    {"destroyCircle", destroyNode},
    {"destroyRectangle", destroyNode},
    {NULL, NULL}
};

// mappings for the circle methods
static const struct luaL_Reg circle_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {"setPosition", setPosition},
    {"setFillColor", setFillColor},
    {"setStrokeColor", setStrokeColor},
    {"addChild", addChild},
    {"runAction", runAction},
    {NULL, NULL}
};

// mappings for the rectangle methods
static const struct luaL_Reg rectangle_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {"setPosition", setPosition},
    {"setFillColor", setFillColor},
    {"setStrokeColor", setStrokeColor},
    {"addChild", addChild},
    {"runAction", runAction},
    {NULL, NULL}
};


// the registration function
int luaopen_shape_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // circle
    createMetatable(L, GEMINI_CIRCLE_LUA_KEY, circle_m);
    //rectangle
    createMetatable(L, GEMINI_RECTANGLE_LUA_KEY, rectangle_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, shapeLib_f);
    
    return 1;
}