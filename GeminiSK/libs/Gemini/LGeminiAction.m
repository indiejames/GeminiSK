//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import "LGeminiAction.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "LGeminiObject.h"
#import "AppDelegate.h"
#import "MyScene.h"
#import "GemDirector.h"
#import "GemAction.h"


static int newRotateAction(lua_State *L){
    GemLog(@"Creating new rotation action");
    
    float angle = luaL_checknumber(L, 1);
    double duration = luaL_checknumber(L, 2);
    
    SKAction *action = [SKAction rotateByAngle:angle duration:duration];
    GemAction *gemAction = [[GemAction alloc] init];
    gemAction.skAction = action;
    
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_ACTION_LUA_KEY];
    luaData.delegate = gemAction;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gemAction.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:luaData];
    
    return 1;
}
// the mappings for the library functions
static const struct luaL_Reg actionLib_f [] = {
    
    {NULL, NULL}
};

// mappings for the scene methods
static const struct luaL_Reg action_m [] = {
    //{"__gc", sceneGC},
    /*{"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"setBackgroundColor", sceneSetBackroundColor},*/
    {NULL, NULL}
};

// the registration function
int luaopen_action_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // scene
    createMetatable(L, GEMINI_ACTION_LUA_KEY, action_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, actionLib_f);
    
    return 1;
}