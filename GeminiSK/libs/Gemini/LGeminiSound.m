//
//  LGeminiSound.m
//  GeminiSK
//
//  Created by James Norton on 12/20/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LGeminiSound.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "GemAction.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"

int newSound(lua_State *L){
    GemLog(@"Creating new sound");
    
    int numArgs = lua_gettop(L);
    
    const char *fileName = luaL_checkstring(L, 1);
    BOOL wait = NO;
    if (numArgs > 1) {
        wait = lua_toboolean(L, 2);
    }
    
    SKAction *action = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%s",fileName] waitForCompletion:wait];
    GemAction *gemAction = [[GemAction alloc] init];
    gemAction.skAction = action;
    
    createObjectAndSaveRef(L, GEMINI_SOUND_LUA_KEY, gemAction);
    
    return 1;
}

int playSound(lua_State *L){
    GemLog(@"Playing sound");
    
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_SOUND_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    SKAction *action = gemAction.skAction;
    [[Gemini shared].director.currentScene runAction:action];
    
    return 0;
    
}

// the mappings for the library functions
static const struct luaL_Reg soundLib_f [] = {
    {"newSound", newSound},
    {"play", playSound},
    {NULL, NULL}
};

// mappings for the sound methods
static const struct luaL_Reg sound_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {NULL, NULL}
};

// the registration function
int luaopen_soundlib (lua_State *L){
    // create meta tables for our various types /////////
    
    // sounds
    createMetatable(L, GEMINI_SOUND_LUA_KEY, sound_m);
    
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, soundLib_f);
    
    return 1;
}
