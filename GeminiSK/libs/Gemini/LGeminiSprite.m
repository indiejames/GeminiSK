//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "LGeminiSprite.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"
#import "LGeminiNode.h"

extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);

static int newSprite(lua_State *L){
    // stack: 1 - texture atlas name
    
    const char *atlasName = luaL_checkstring(L, 1);
    GemLog(@"Creating new sprite with texture atlas %s", atlasName);
    
    NSString *firstTextureName = [NSString stringWithFormat:@"%s.0001.png", atlasName];
    
    [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"%s", atlasName]];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:firstTextureName]];
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_SPRITE_LUA_KEY];
    luaData.delegate = sprite;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    sprite.userData = wrapper;
    
    [[Gemini shared].geminiObjects addObject:sprite];
    
    return 1;
}



// the mappings for the library functions
static const struct luaL_Reg spriteLib_f [] = {
    {"newSprite", newSprite},
    //{"destroySprite", destroySprite},
    {NULL, NULL}
};

// mappings for the sprite methods
static const struct luaL_Reg sprite_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {"setPosition", setPosition},
    {"addChild", addChild},
    {"runAction", runAction},
    {NULL, NULL}
};

// the registration function
int luaopen_sprite_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // sprite
    createMetatable(L, GEMINI_SPRITE_LUA_KEY, sprite_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, spriteLib_f);
    
    return 1;
}