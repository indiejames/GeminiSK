//
//  LGeminiTexture.m
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "LGeminiTexture.h"
#import "GemTextureAtlas.h"
#import "GemTexture.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"
#import "LGeminiNode.h"


extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);

static int newTextureAtlas(lua_State *L){
    // stack: 1 - texture atlas name
    
    const char *atlasName = luaL_checkstring(L, 1);
    GemLog(@"Creating new texture atlas with name %s", atlasName);
    
    GemTextureAtlas *atlas = [[GemTextureAtlas alloc] initWithAtlasNamed:[NSString stringWithFormat:@"%s", atlasName]];
    
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_TEXTURE_ATLAS_LUA_KEY];
    luaData.delegate = atlas;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    atlas.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:atlas];
    
    return 1;
}

static int newTexture(lua_State *L){
    // stack: 1 - texture atlas, 2 - texture image name
    
     __unsafe_unretained GemObject **gemObj = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_TEXTURE_ATLAS_LUA_KEY);
   
    GemTextureAtlas *atlas = (GemTextureAtlas *)(*gemObj).delegate;
    
    const char *imageName = luaL_checkstring(L, 2);
    
    GemTexture *texture = [[GemTexture alloc] initWithImageNamed:[NSString stringWithFormat:@"%s",imageName] textureAtlas:atlas];
    
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_TEXTURE_LUA_KEY];
    luaData.delegate = texture;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    texture.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:texture];
    
    return 1;
}


// the mappings for the library functions
static const struct luaL_Reg texture_lib_f [] = {
    {"newTextureAtlas", newTextureAtlas},
    {"newTexture", newTexture},
    {NULL, NULL}
};

// mappings for the texture atlas methods
static const struct luaL_Reg texture_atlas_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {NULL, NULL}
};

// mappings for the texture methods
static const struct luaL_Reg texture_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {NULL, NULL}
};

// the registration function
int luaopen_texture_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // texture atlas
    createMetatable(L, GEMINI_TEXTURE_ATLAS_LUA_KEY, texture_atlas_m);
    
    // texture
    createMetatable(L, GEMINI_TEXTURE_LUA_KEY, texture_m);
    
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, texture_lib_f);
    
    return 1;
}