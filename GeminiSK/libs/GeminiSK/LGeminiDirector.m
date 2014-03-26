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
#import "GemDirector.h"
#import "GemSKScene.h"
#import "LGeminiNode.h"

#pragma mark Utitly Methods
GemSKScene *getScene(lua_State *L){
    __unsafe_unretained GemObjectWrapper  **obj = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    return (GemSKScene *)(*obj).delegate;
}

#pragma  mark -


#pragma mark Factory Methods

static int newScene(lua_State *L){
    GemLog(@"Creating new scene");
    
    SKView *skView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).skView;
    
    GemSKScene *scene = [[GemSKScene alloc] initWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    
    createObjectAndSaveRef(L, GEMINI_SCENE_LUA_KEY, scene);
    
    return 1;
}

#pragma  mark -

static int sceneGC (lua_State *L){
    //NSLog(@"lineGC called");
   // __unsafe_unretained GemScene  **scene = (__unsafe_unretained GemScene **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    //[(*line).parent remove:*line];
   
    
    return 0;
}


static int directorLoadScene(lua_State *L){
    
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    NSLog(@"Loading scene");
    GemSKScene *scene = [[Gemini shared].director loadScene:sceneNameStr];
    
    GemObjectWrapper *luaData = [scene.userData objectForKey:@"LUA_DATA"];
    
    // push our attached Lua object's userdata onto the stack
    lua_rawgeti(L, LUA_REGISTRYINDEX, luaData.selfRef);
    
    return 1;
}

static int directorGotoScene(lua_State *L){
    
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    
    NSDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (lua_istable(L, 2)) {
        params = getTableFromStack(L, 2);
    }
    
    
    [[Gemini shared].director gotoScene:sceneNameStr withOptions:params];
    
    return 0;
}

static int deleteScene(lua_State *L){
    const char *sceneName = luaL_checkstring(L, 1);
    NSString *sceneNameStr = [NSString stringWithUTF8String:sceneName];
    NSLog(@"LGeminiDirector deleting scene %@", sceneNameStr);
     [[Gemini shared].director destroyScene:sceneNameStr];
    
    return 0;
    
}

#pragma mark Scene Methods

static int sceneSetBackroundColor(lua_State *L){
    int numargs = lua_gettop(L);
    GemSKScene *scene = getScene(L);
    
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

static int sceneSetBackgroundImage(lua_State *L){
    GemSKScene *scene = getScene(L);
    const char *imageFile = luaL_checkstring(L, 2);
    NSString *imageFileStr = [NSString stringWithFormat:@"%s", imageFile];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageFileStr];
    sprite.position = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame));
    sprite.name = @"Background";
    sprite.size = scene.size;
    [scene addChild:sprite];
               
    return 0;
}

static int sceneSetSize(lua_State *L){
    __unsafe_unretained GemObjectWrapper  **obj = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    SKScene *scene = (SKScene *)(*obj).delegate;
    
    GLfloat width = luaL_checknumber(L, 2);
    GLfloat height = luaL_checknumber(L, 3);
    
    scene.size = CGSizeMake(width, height);
    
    return 0;
}

static int sceneSetPosition(lua_State *L){
    __unsafe_unretained GemObjectWrapper  **obj = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_SCENE_LUA_KEY);
    SKScene *scene = (SKScene *)(*obj).delegate;
    
    GLfloat x = luaL_checknumber(L, 2);
    GLfloat y = luaL_checknumber(L, 3);
    
    scene.position = CGPointMake(x, y);
    
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
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"setBackgroundColor", sceneSetBackroundColor},
    {"setBackgroundImage", sceneSetBackgroundImage},
    {"addEventListener", addEventListener},
    {"addChild", addChild},
    {"setSize", sceneSetSize},
    {"setPosition", sceneSetPosition},
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