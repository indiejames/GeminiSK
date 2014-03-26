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
#import "LGeminiTexture.h"
#import "GemTexture.h"
#import "GemSKSpriteNode.h"

extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);

SKSpriteNode *getSprite(lua_State *L){
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)lua_touserdata(L, 1);
    return (SKSpriteNode *)(*go).delegate;

}



static int newSprite(lua_State *L){
    // stack: 1 - texture
    GemTexture *texture = getTexture(L);
    
    GemSKSpriteNode *sprite = [[GemSKSpriteNode alloc] initWithGemTexture:texture];
       
    createObjectAndSaveRef(L, GEMINI_SPRITE_LUA_KEY, sprite);
    
    return 1;
}

static int newIndex(lua_State *L) {
    SKSpriteNode *sprite = getSprite(L);
    
    const char *attr = luaL_checkstring(L, 2);
    
    // handle texture assginment
    if (strcmp(attr, "texture") == 0) {
        GemTexture *texture = getTextureAtIndex(L, 3);
        sprite.texture = texture.texture;
        
        return 0;
        
    }
    
    // use the generic index function for everything else
    return genericNewIndex(L);
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
    {"__newindex", newIndex},
    {"addEventListener", addEventListener},
    {"getPosition", getPosition},
    {"setPosition", setPosition},
    {"addChild", addChild},
    {"removeFromParent", removeFromParent},
    {"runAction", runAction},
    {"removeAllActions", removeAllActions},
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