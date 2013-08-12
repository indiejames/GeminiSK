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
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_LABEL_LUA_KEY];
    luaData.delegate = label;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    label.userData = wrapper;
    
    return 1;
}

static int labelGC (lua_State *L){
    //NSLog(@"lineGC called");
   // __unsafe_unretained GemScene  **scene = (__unsafe_unretained GemScene **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    //[(*line).parent remove:*line];
   
    
    return 0;
}


static int labelIndex(lua_State *L){
    int rval = 0;
   // __unsafe_unretained SKScene  **scene = (__unsafe_unretained SKScene **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    __unsafe_unretained GemObject **obj = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_LABEL_LUA_KEY);
    if (obj != NULL) {
        rval = genericNodeIndex(L, (SKNode *)(*obj).delegate);
    }
    
    return rval;
}

static int labelNewIndex (lua_State *L){
    // stack -  1 - object, 2 - attribute, 3 - value
    int rval = 0;
    __unsafe_unretained GemObject  **obj = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_LABEL_LUA_KEY);
    SKLabelNode *label = (SKLabelNode *)(*obj).delegate;
    
    if (lua_isstring(L, 2)) {
         const char *key = lua_tostring(L, 2);
        
        if (strcmp("text", key) == 0) {
            const char *text = lua_tostring(L, 3);
            
            label.text = [NSString stringWithFormat:@"%s", text];
            rval = 0;
        } else if (strcmp("fontSize", key) == 0){
            GLfloat fontSize = luaL_checknumber(L, 3);
            label.fontSize = fontSize;
        } else {
            rval = genericNodeNewIndex(L, label);
        }
    } else {
        rval = genericNodeNewIndex(L, label);
    }
    
    return rval;
}

static int deleteLabel(lua_State *L){
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    NSLog(@"LGeminiDirector deleting scene %@", sceneNameStr);
  //  [((GemGLKViewController *)[Gemini shared].viewController).director destroyScene:sceneNameStr];
    
    return 0;
    
}

// scene methods

/*static int sceneSetBackroundColor(lua_State *L){
    int numargs = lua_gettop(L);
    __unsafe_unretained GemObject  **obj = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    SKScene *scene = (SKScene *)(*obj).delegate;
    
    GLfloat red = luaL_checknumber(L, 2);
    GLfloat green = luaL_checknumber(L, 3);
    GLfloat blue = luaL_checknumber(L, 4);
    GLfloat alpha = 1.0;
    if (numargs == 5) {
        alpha = luaL_checknumber(L, 5);
    }
    
    SKColor *backgroundColor = [SKColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    scene.backgroundColor = backgroundColor;
    
    return 0;
}*/

// the mappings for the library functions
static const struct luaL_Reg uiLib_f [] = {
    {"newLabel", newLabel},
    {NULL, NULL}
};

// mappings for the label methods
static const struct luaL_Reg label_m [] = {
    //{"__gc", sceneGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    //{"setBackgroundColor", sceneSetBackroundColor},
    /*{"addLayer", addLayerToScene},
    {"addNativeObject", addNativeObjectToScene},*/
    {"addEventListener", addEventListener},
    {"setPosition", setPosition},
    //{"zoom", zoomScene},
    //{"pan", panScene},
    //{"resetCamera", resetSceneCamera},
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