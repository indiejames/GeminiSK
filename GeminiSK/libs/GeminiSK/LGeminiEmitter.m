//
//  LGeminiEmitter.m
//  GeminiSK
//
//  Created by James Norton on 2/21/14.
//
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "LGeminiEmitter.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"


extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);

static int newEmitter(lua_State *L){
    // stack: 1 - emitter file name (no extension), 2 - x (optional), 3 - y (optional)
    
    GemLog(@"Creating new emitter");
    const char *filename = luaL_checkstring(L, 1);
    
    float x = 0;
    float y = 0;
    
    if (lua_gettop(L) > 1) {
        x = luaL_checknumber(L, 2);
    }
    
    if (lua_gettop(L) > 2) {
        y = luaL_checknumber(L, 3);
    }
    
    NSString *fileNameStr = [NSString stringWithFormat:@"%s", filename];
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:fileNameStr ofType:@"sks"];
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    
    emitter.position = CGPointMake(x, y);
    
    createObjectAndSaveRef(L, GEMINI_EMITTER_LUA_KEY, emitter);
    
    [emitter.userData setObject:@"EMITTER" forKey:@"TYPE"]; // TODO - replace type strings with constants
    
    
    return 1;
}

// emitter methods

static int setTargetNode(lua_State *L){
    // stack 1 - emitter, 2 - target node
    SKEmitterNode *emitter = (SKEmitterNode *)getNodeAtIndex(L, 1);
    SKNode *target = (SKEmitterNode *)getNodeAtIndex(L, 2);
    
    [emitter setTargetNode:target];
    //emitter.particleLifetime = 50;
    
    return 0;
}


// the mappings for the library functions
static const struct luaL_Reg emitterLib_f [] = {
    {"newEmitter", newEmitter},
    {"destroyEmitter", destroyNode},
    {NULL, NULL}
};

// mappings for the circle methods
static const struct luaL_Reg emitter_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {"addChild", addChild},
    {"runAction", runAction},
    {"setTarget", setTargetNode},
    {NULL, NULL}
};

// the registration function
int luaopen_emitter_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // emitter
    createMetatable(L, GEMINI_EMITTER_LUA_KEY, emitter_m);

    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, emitterLib_f);
    
    return 1;
}