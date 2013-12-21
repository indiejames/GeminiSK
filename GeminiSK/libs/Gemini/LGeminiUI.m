//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import "LGeminiUI.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"

extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);


static int newLabel(lua_State *L){
    // stack: 1 - font string
    
    GemLog(@"Creating new label");
    
    const char *fontStr = luaL_checkstring(L, 1);
     
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:[NSString stringWithFormat:@"%s", fontStr]];
    
    createObjectAndSaveRef(L, GEMINI_LABEL_LUA_KEY, label);
    
    return 1;
}

// the mappings for the library functions
static const struct luaL_Reg uiLib_f [] = {
    {"newLabel", newLabel},
    {"destroyLabel", destroyNode},
    {NULL, NULL}
};

// mappings for the label methods
static const struct luaL_Reg label_m [] = {
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
int luaopen_ui_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // scene
    createMetatable(L, GEMINI_LABEL_LUA_KEY, label_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, uiLib_f);
    
    return 1;
}