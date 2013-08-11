//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import "LGeminiDirector.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "LGeminiObject.h"
#import "AppDelegate.h"
#import "MyScene.h"
#import "GemDirector.h"


static int newScene(lua_State *L){
    NSLog(@"Creating new scene");
    
   // GemScene *scene = [[GemScene alloc] initWithLuaState:L defaultLayerIndex:0];
//    [((GemGLKViewController *)[Gemini shared].viewController).director addScene:scene];
   
    SKView *skView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).skView;
    
    SKScene *scene = [[MyScene alloc] initWithSize:skView.bounds.size];
    GemObject *luaData = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_SCENE_LUA_KEY];
    luaData.delegate = scene;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    scene.userData = wrapper;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    //[skView presentScene:scene];
    
    
    return 1;
}

static int sceneGC (lua_State *L){
    //NSLog(@"lineGC called");
   // __unsafe_unretained GemScene  **scene = (__unsafe_unretained GemScene **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    //[(*line).parent remove:*line];
   
    
    return 0;
}


static int sceneIndex(lua_State *L){
    int rval = 0;
   // __unsafe_unretained SKScene  **scene = (__unsafe_unretained SKScene **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    __unsafe_unretained GemObject **obj = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    if (obj != NULL) {
        rval = genericNodeIndex(L, (SKNode *)(*obj).delegate);
    }
    
    return rval;
}

static int sceneNewIndex (lua_State *L){
    int rval = 0;
    __unsafe_unretained GemObject  **obj = (__unsafe_unretained GemObject **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    if (obj != NULL) {
        rval = genericNodeNewIndex(L, (SKNode *)(*obj).delegate);
    }
    
    return rval;
}

static int directorLoadScene(lua_State *L){
    
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    NSLog(@"Loading scene");
  //  [((GemGLKViewController *)[Gemini shared].viewController).director loadScene:sceneNameStr];
    [[Gemini shared].director loadScene:sceneNameStr];
    
    
    return 0;
}

static int directorGotoScene(lua_State *L){
    
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (lua_istable(L, 2)) {
        lua_pushnil(L);  /* first key */
        while (lua_next(L, 2) != 0) {
            /* uses 'key' (at index -2) and 'value' (at index -1) */
            printf("%s - %s\n",
                   lua_typename(L, lua_type(L, -2)),
                   lua_typename(L, lua_type(L, -1)));
            const char *key = lua_tostring(L, -2);
            const char *value = lua_tostring(L, -1);
            [params setObject:[NSString stringWithUTF8String:value] forKey:[NSString stringWithUTF8String:key]];
                        
            /* removes 'value'; keeps 'key' for next iteration */
            lua_pop(L, 1);
        }
    }
    
    [[Gemini shared].director gotoScene:sceneNameStr withOptions:params];
    
    return 0;
}

static int deleteScene(lua_State *L){
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    NSLog(@"LGeminiDirector deleting scene %@", sceneNameStr);
  //  [((GemGLKViewController *)[Gemini shared].viewController).director destroyScene:sceneNameStr];
    
    return 0;
    
}

// scene methods

static int sceneSetBackroundColor(lua_State *L){
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
}

// the mappings for the library functions
static const struct luaL_Reg directorLib_f [] = {
    {"newScene", newScene},
    {"loadScene", directorLoadScene},
    {"gotoScene", directorGotoScene},
    {"destroyScene", deleteScene},
    {NULL, NULL}
};

// mappings for the scene methods
static const struct luaL_Reg scene_m [] = {
    //{"__gc", sceneGC},
    {"__index", sceneIndex},
    {"__newindex", sceneNewIndex},
    {"setBackgroundColor", sceneSetBackroundColor},
    /*{"addLayer", addLayerToScene},
    {"addNativeObject", addNativeObjectToScene},*/
    {"addEventListener", addEventListener},
    {"addChild", addChild},
    //{"zoom", zoomScene},
    //{"pan", panScene},
    //{"resetCamera", resetSceneCamera},
    {NULL, NULL}
};

// the registration function
int luaopen_director_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // scene
    createMetatable(L, GEMINI_SCENE_LUA_KEY, scene_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, directorLib_f);
    
    return 1;
}