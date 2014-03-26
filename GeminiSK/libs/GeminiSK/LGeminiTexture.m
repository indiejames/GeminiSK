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
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"
#import "LGeminiNode.h"


extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);

#pragma mark Utility Methods

GemTexture *getTextureAtIndex(lua_State *L, int index){
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, index, GEMINI_TEXTURE_LUA_KEY);
    return (GemTexture *)(*go).delegate;

}

GemTexture *getTexture(lua_State *L){
    return getTextureAtIndex(L, 1);
}

#pragma  mark --

static int newTextureAtlas(lua_State *L){
    // stack: 1 - texture atlas name
    
    const char *atlasName = luaL_checkstring(L, 1);
    GemLog(@"Creating new texture atlas with name %s", atlasName);
    
    GemTextureAtlas *atlas = [[GemTextureAtlas alloc] initWithAtlasNamed:[NSString stringWithFormat:@"%s", atlasName]];
    
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_TEXTURE_ATLAS_LUA_KEY];
    luaData.delegate = atlas;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    atlas.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:atlas];
    
    return 1;
}

static int newTexture(lua_State *L){
    GemTexture *texture;
    
    if (luaL_checkstring(L, 1)) {
        // load from image file
        const char *imageName = luaL_checkstring(L, 1);
        texture = [[GemTexture alloc] initWithImagenamed:[NSString stringWithFormat:@"%s", imageName]];
        
    } else {
        // load from texture atlas
         __unsafe_unretained GemObjectWrapper **gemObj = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_TEXTURE_ATLAS_LUA_KEY);
       
        GemTextureAtlas *atlas = (GemTextureAtlas *)(*gemObj).delegate;
        
        const char *imageName = luaL_checkstring(L, 2);
        
        texture = [[GemTexture alloc] initWithImageNamed:[NSString stringWithFormat:@"%s",imageName] textureAtlas:atlas];
    }
    
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_TEXTURE_LUA_KEY];
    luaData.delegate = texture;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    texture.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:texture];
    
    return 1;
}

static int newSubTexture(lua_State *L){
     __unsafe_unretained GemObjectWrapper **gemObj = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_TEXTURE_LUA_KEY);
    
    GemTexture *texture = (GemTexture *)(*gemObj).delegate;
    
    CGFloat x0 = luaL_checknumber(L, 2);
    CGFloat y0 = luaL_checknumber(L, 3);
    CGFloat x1 = luaL_checknumber(L, 4);
    CGFloat y1 = luaL_checknumber(L, 5);
    
    SKTexture *subTexture = [SKTexture textureWithRect:CGRectMake(x0, y0, x1-x0, y1-y0) inTexture:texture.texture];
    GemTexture *gsubTexture = [[GemTexture alloc] initWithTexture:subTexture];
    
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_TEXTURE_LUA_KEY];
    luaData.delegate = gsubTexture;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gsubTexture.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:gsubTexture];
    
    return 1;
}


// the mappings for the library functions
static const struct luaL_Reg texture_lib_f [] = {
    {"newTextureAtlas", newTextureAtlas},
    {"newTexture", newTexture},
    {"newSubTexture", newSubTexture},
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