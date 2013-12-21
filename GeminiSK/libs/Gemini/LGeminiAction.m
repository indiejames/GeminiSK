//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import "LGeminiAction.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "LGeminiObject.h"
#import "AppDelegate.h"
#import "GemDirector.h"
#import "GemAction.h"
#import "GemRepeatAction.h"
#import "GemTexture.h"
#import "GemSpriteAnimationAction.h"
#import "GemBezierPath.h"

#define VALUES_PER_POINT 2

// create a Lua action form a GemAction and push it on the stack
// also saves the wrapper object to prevent its GC
void makeAction(lua_State *L, GemAction *gemAction) {
    
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:GEMINI_ACTION_LUA_KEY];
    luaData.delegate = gemAction;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    gemAction.userData = wrapper;
    
    // keep the action wrapper from being GC'ed
    [[Gemini shared].geminiObjects addObject:gemAction];
}

static int animateSpriteWithTextures(lua_State *L){
    GemLog(@"Creating new sprite animation action");
    
    int numArgs = lua_gettop(L);
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numArgs-1];
    
    for (int i=1; i<numArgs; i++) {
        //const char *frame = luaL_checkstring(L, i);
        //SKTexture *tex = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%s",frame]];
        // Force texture to be loaded to avoid SK bug causing sprite to be rendered twice its size
        // initially
        //CGFloat height = tex.size.height;
        
        __unsafe_unretained GemObjectWrapper **gemObj = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, i, GEMINI_TEXTURE_LUA_KEY);
        
        GemTexture *tex = (GemTexture *)(*gemObj).delegate;
        
        [frames addObject:tex];
    }
    
    double timerPerFrame = luaL_checknumber(L, numArgs);
    
    GemSpriteAnimationAction *gemAction = [[GemSpriteAnimationAction alloc] initWithTextures:frames timePerFrame:timerPerFrame];
    
    createObjectAndSaveRef(L, GEMINI_ACTION_LUA_KEY, gemAction);
    
    return 1;
}

static int repeatAction(lua_State *L){
    GemLog(@"Creating new repeat action");
    
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_ACTION_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    
    int repeatCount = luaL_checknumber(L, 2);
    /*
    if (repeatCount < 1) {
        rAction = [SKAction repeatActionForever:skAction];
    } else {
        rAction = [SKAction repeatAction:skAction count:(uint)repeatCount];
    }
    
    GemAction *newGemAction = [[GemAction alloc] init];
    newGemAction.skAction = rAction;*/
    
    GemRepeatAction *repAction = [[GemRepeatAction alloc] initWithAction:gemAction count:repeatCount];
    
    
    createObjectAndSaveRef(L, GEMINI_ACTION_LUA_KEY, repAction);
    
    return 1;

}

static int newRotateAction(lua_State *L){
    GemLog(@"Creating new rotation action");
    
    float angle = luaL_checknumber(L, 1);
    double duration = luaL_checknumber(L, 2);
    
    SKAction *action = [SKAction rotateByAngle:angle duration:duration];
    GemAction *gemAction = [[GemAction alloc] init];
    gemAction.skAction = action;
    
    createObjectAndSaveRef(L, GEMINI_ACTION_LUA_KEY, gemAction);
    
    return 1;
}

static int newFollowPathWithDuration(lua_State *L){
    GemLog(@"Creating new follow path with duration action");
    
    int numargs = lua_gettop(L);
    
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_PATH_LUA_KEY);
    GemBezierPath *path = (GemBezierPath *)(*go).delegate;
    
    double duration = luaL_checknumber(L, 2);
    
    
    BOOL asOffset = YES;
    BOOL orientToPath = YES;
    
    if (numargs > 2) {
        asOffset = lua_toboolean(L, 3);
    }
    
    if (numargs > 3) {
        orientToPath = lua_toboolean(L, 4);
    }
  
    SKAction *action = [SKAction followPath:path.path.CGPath asOffset:asOffset orientToPath:orientToPath duration:duration];
    GemAction *gemAction = [[GemAction alloc] init];
    gemAction.skAction = action;
    createObjectAndSaveRef(L, GEMINI_ACTION_LUA_KEY, gemAction);
    
    return 1;
}

static int newMoveToXAction(lua_State *L){
    GemLog(@"Creating new rotation action");
    
    float x = luaL_checknumber(L, 1);
    double duration = luaL_checknumber(L, 2);
    
    SKAction *action = [SKAction moveToX:x duration:duration];
    GemAction *gemAction = [[GemAction alloc] init];
    gemAction.skAction = action;
   
    createObjectAndSaveRef(L, GEMINI_ACTION_LUA_KEY, gemAction);
    
    return 1;
}


static int deleteAction(lua_State *L){
    __unsafe_unretained GemObjectWrapper **go = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, 1, GEMINI_ACTION_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    
    // allow the action wrapper to be GC'ed
    [[Gemini shared].geminiObjects removeObject:gemAction];
    
    return 0;

}

// the mappings for the library functions
static const struct luaL_Reg actionLib_f [] = {
    {"rotate", newRotateAction},
    {"moveToX", newMoveToXAction},
    {"followPath", newFollowPathWithDuration},
    {"animate", animateSpriteWithTextures},
    {"repeatAction", repeatAction},
    {NULL, NULL}
};

// mappings for the action methods
static const struct luaL_Reg action_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"delete", deleteAction},
    {NULL, NULL}
};

// the registration function
int luaopen_action_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // scene
    createMetatable(L, GEMINI_ACTION_LUA_KEY, action_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, actionLib_f);
    
    return 1;
}