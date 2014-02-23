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
#import "GemAVAudioPlayer.h"

# pragma mark Utility Methods
GemAVAudioPlayer *getAudioPlayerAtIndex(lua_State *L, int index){
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)lua_touserdata(L, index);
    
    return (GemAVAudioPlayer *)(*go).delegate;
}

GemAVAudioPlayer *getAudioPlayer(lua_State *L){
    return getAudioPlayerAtIndex(L, 1);
}

#pragma  mark -

#pragma  mark Factory Methods

static int newSound(lua_State *L){
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

static int newAudioPlayer(lua_State *L){
    GemLog(@"Creating new audio player");
    
    const char *audioFile = luaL_checkstring(L, 1);
    
    NSString *audioFileStr = [NSString stringWithFormat:@"%s", audioFile];
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:audioFileStr ofType:nil];
    GemAVAudioPlayer *player = [[GemAVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioFilePath] error:NULL];
    
    // TODO - add some error handling for the init of the audio player
    
    createObjectAndSaveRef(L, GEMINI_AUDIO_PLAYER_LUA_KEY, player);
    
    
    return 1;
}

static int playSound(lua_State *L){
    GemLog(@"Playing sound");
    
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_SOUND_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    SKAction *action = gemAction.skAction;
    [[Gemini shared].director.currentScene runAction:action];
    
    return 0;
    
}

#pragma  mark -

# pragma mark Audio Player methods

static int play(lua_State *L){
    // stack 1 - audio player, 2 - delay (optional)
    GemAVAudioPlayer *player = getAudioPlayer(L);
    
    NSTimeInterval delay = 0;
    if (lua_gettop(L) > 1) {
        delay = luaL_checknumber(L, 2);
    }
    
    BOOL ok = [player playAtTime:player.deviceCurrentTime + delay];
    
    if (ok) {
        lua_pushboolean(L, true);
    } else {
        lua_pushboolean(L, false); // TODO - move this out to a common method
    }
    
    return 1;
}

static int prepareToPlay(lua_State *L){
    GemAVAudioPlayer *player = getAudioPlayer(L);
    
    BOOL ok = [player prepareToPlay];
    
    if (ok) {
        lua_pushboolean(L, true);
    } else {
        lua_pushboolean(L, false);
    }
    
    return 1;
}

#pragma  mark -

// the mappings for the library functions
static const struct luaL_Reg soundLib_f [] = {
    {"newSound", newSound},
    {"newAudioPlayer", newAudioPlayer},
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

// mappings for the audio player methods
static const struct luaL_Reg audioPlayer_m [] = {
    {"play", play},
    {"prepareToPlay", prepareToPlay},
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
    
    // sound players
    createMetatable(L, GEMINI_AUDIO_PLAYER_LUA_KEY, audioPlayer_m);
    
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, soundLib_f);
    
    return 1;
}
