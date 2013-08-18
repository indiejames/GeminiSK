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
    
    // keep the action wrapper from being GC'ed
    [[Gemini shared].geminiObjects addObject:gemAction];
    
    return 1;
}

static int deleteAction(lua_State *L){
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_ACTION_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    
    // allow the action wrapper to be GC'ed
    [[Gemini shared].geminiObjects removeObject:gemAction];
    
    return 0;

}

// the mappings for the library functions
static const struct luaL_Reg actionLib_f [] = {
    {"rotate", newRotateAction},
    {NULL, NULL}
};

// mappings for the action methods
static const struct luaL_Reg action_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"delete", deleteAction},
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