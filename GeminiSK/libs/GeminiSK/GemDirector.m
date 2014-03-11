//
//  GemDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/17/12.
//
//

#import "GemDirector.h"
#import "Gemini.h"
#import "LGeminiDirector.h"
#import "GemEvent.h"
#import "LGeminiLuaSupport.h"
#import "Gemini.h"
#import "GemFileNameResolver.h"
#import "AppDelegate.h"
#import "GemSKScene.h"

@implementation GemDirector {
    NSMutableArray *sceneQueue;
    GemSKScene *activeScene;
}

int render_count = 0;

-(id)initWithLuaState:(lua_State *)luaState {
    self = [super init];
    
    if (self) {
        luaData = [[GemObjectWrapper alloc] initWithLuaState:luaState];
        scenes = [[NSMutableDictionary alloc] initWithCapacity:1];
        loadingScenes = [[NSMutableSet alloc] initWithCapacity:1];
        sceneQueue = [NSMutableArray arrayWithCapacity:1];
        activeScene = nil;
    }
    
    return self;
}

-(void)setActiveScene:(GemSKScene *)activeScn {
    activeScene = activeScn;
}

-(GemSKScene *)activeScene {
    return activeScene;
}

// block for loading scenes
GemSKScene * (^sceneLoader)(GemDirector *self, NSString *sceneName, lua_State *L) = ^GemSKScene *(GemDirector *self, NSString * sceneName, lua_State *L) {
    int err;
    
    GemLog(@"Gem: Loading scene %@", sceneName);
    
    //lockLuaLock();
    
    lua_settop(L, 0);
    
    // set our error handler function
    lua_pushcfunction(L, traceback);
    
    GemFileNameResolver *resolver = [Gemini shared].fileNameResolver;
    
    NSString *resolvedFileName = [resolver resolveNameForFile:sceneName ofType:@"lua"];
    
    NSString *luaFilePath = [[NSBundle mainBundle] pathForResource:resolvedFileName ofType:@"lua"];
    
    err = luaL_loadfile(L, [luaFilePath cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    
    if (0 != err) {
        luaL_error(L, "LUA ERROR: cannot load lua file: %s",
                   lua_tostring(L, -1));
        return nil;
    }
    
    
    err = lua_pcall(L, 0, 1, 1);
    if (0 != err) {
        luaL_error(L, "LUA ERROR: cannot run lua file: %s",
                   lua_tostring(L, -1));
        return nil;
    }
    
    // The scene should now be on the top of the stack
    __unsafe_unretained GemObjectWrapper **lscene = (__unsafe_unretained GemObjectWrapper **)luaL_checkudata(L, -1, GEMINI_SCENE_LUA_KEY);
    
    //SKView *skView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).skView;
    CGRect bounds = CGRectMake(0, 0, self.sceneWidth, self.sceneHeight);
    bounds.size.width = 1136;
    bounds.size.height = 640;
    GemSKScene *scene = [[GemSKScene alloc] initWithSize:bounds.size];
    scene.name = sceneName;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:*lscene forKey:@"LUA_DATA"];
    scene.userData = wrapper;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    (*lscene).delegate = scene;

    self.activeScene = scene;
    
    [scene callMethodOnScene:@"createScene"];
    
    return scene;
};

/*-(unsigned int)percentLoaded:(NSString *)sceneName {
    if ([loadingScenes containsObject:sceneName]) {
        
    }
}*/

-(GemSKScene *)loadScene:(NSString *)sceneName {
    GemSKScene *scene;
    // don't load the scene if it is already in our cache
    if ([scenes objectForKey:sceneName] == nil && ![loadingScenes containsObject:sceneName]) {
        
        [loadingScenes addObject:sceneName];
        
        scene = sceneLoader(self, sceneName, luaData.L);
        [scenes setObject:scene forKey:sceneName];
        [loadingScenes removeObject:sceneName];

    } else {
        scene = (GemSKScene *)[scenes objectForKey:sceneName];
    
    }
    
    return scene;
    
}

SKTransition *transitionFromParams(NSDictionary *params){
    NSString *transitionType = [params objectForKey:TRANSITION_TYPE_KEY];
    
    SKTransition *trans;
    
    double duration = 1.5;
    if ([params objectForKey:DURATION_KEY]) {
        NSNumber *dnum = [params objectForKey:DURATION_KEY];
        duration = [dnum doubleValue];
    }
    
    if ([transitionType isEqualToString:CI_FILTER_TYPE]) {
        NSString *ciFilterName = [params objectForKey:CI_FILTER_NAME];
        CIFilter *filter = [CIFilter filterWithName:ciFilterName];
        NSDictionary *filterParams = [params objectForKey:FILTER_PARAMS_KEY];
        if (filterParams != nil) {
            for(id key in filterParams){
                [filter setValue:[filterParams objectForKey:key] forKey:key];
            }
        }
        
        trans = [SKTransition transitionWithCIFilter:filter duration:duration];
    } else if ([transitionType isEqualToString:PUSH]) {
        SKTransitionDirection direction = SKTransitionDirectionLeft;
        
        NSString *directionStr = [params objectForKey:DIRECTION];
        if ([directionStr isEqualToString:UP]) {
            direction = SKTransitionDirectionUp;
        } else if ([directionStr isEqualToString:DOWN]){
            direction = SKTransitionDirectionDown;
        } else if ([directionStr isEqualToString:RIGHT]) {
            direction = SKTransitionDirectionLeft;
        }
        
        trans = [SKTransition pushWithDirection:direction duration:duration];
    } else if ([transitionType isEqualToString:FLIP]){
        NSString *orientation = [params objectForKey:ORIENTATION];
        if ([orientation isEqualToString:VERTICAL]) {
            trans = [SKTransition flipVerticalWithDuration:duration];
        } else {
            trans = [SKTransition flipHorizontalWithDuration:duration];
        }
        
    } else {
        // default
        trans = [SKTransition fadeWithDuration:duration];
    }
    
    if ([params objectForKey:PAUSES_OUTGOING_SCENE_KEY]) {
        NSNumber *val = [params objectForKey:PAUSES_OUTGOING_SCENE_KEY];
        if ([val boolValue]) {
            trans.pausesOutgoingScene = YES;
        }
    }
    
    if ([params objectForKey:PAUSES_INCOMING_SCENE_KEY]) {
        NSNumber *val = [params objectForKey:PAUSES_INCOMING_SCENE_KEY];
        if ([val boolValue]) {
            trans.pausesIncomingScene = YES;
        }
    }
    
    return trans;
}

-(BOOL)doPendingSceneTransition {
    BOOL transitioned = NO;
    if ([sceneQueue count] > 0) {
        NSArray *queObj = [sceneQueue objectAtIndex:0];
        GemSKScene *sceneName = [queObj objectAtIndex:0];
        GemSKScene *scene = (GemSKScene *)[scenes objectForKey:sceneName];
        
        if ([scene isReady]) {
            GemLog(@"Transitioning to scene %@", scene.name);
            NSDictionary *options = [queObj objectAtIndex:1];
            SKTransition *trans = transitionFromParams(options);
            
            [sceneQueue removeObject:queObj];
            
            SKView *skView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).skView;
            
            //[skView presentScene:scene];
            if (trans == nil) {
                GemLog(@"Transition is nil");
            }
            [skView presentScene:scene transition:trans];
            currentScene = scene;
            transitioned = YES;
        } else {
            GemLog(@"Scene %@ is not ready", scene.name);
        }
    } else {
        //GemLog(@"No scenes in queue");
    }
    
    return transitioned;
}

-(void)gotoScene:(NSString *)sceneName withOptions:(NSDictionary *)options {
    
    // load the scene if it is not already loaded or being loaded
    [self loadScene:sceneName];
    
    //SKView *skView = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).skView;
    NSArray *queuObj = [NSArray arrayWithObjects:sceneName, options, nil];
    
    //GemSKScene *scene = (GemSKScene *)[scenes objectForKey:sceneName];
    
    GemLog(@"Adding scene %@ to scene queue", sceneName);
    
    [sceneQueue addObject:queuObj];
    
    if ([[options objectForKey:@"synchronous"] isEqualToString:@"true"]) {
        // try to load it immediately
        while(![self doPendingSceneTransition]){
            [NSThread sleepForTimeInterval:0.01];
        };
    }
}

-(GemSKScene *)currentScene {
    return currentScene;
}

-(void)destroyScene:(NSString *)sceneName {
    // TODO - add logic to check if scene is still loading
    if ([scenes objectForKey:sceneName]){
        [scenes removeObjectForKey:sceneName];
    }
}

// choose the best file based on name and device type
/*NSString *resolveFileName(NSString *fileName){
    NSArray *fileSuffixArray = [fileName componentsSeparatedByString:@"."];
    NSString *base = [fileSuffixArray objectAtIndex:0];
    NSString *suffix = [fileSuffixArray objectAtIndex:1];
    
    NSString *rval = nil;
    
    switch (((GemGLKViewController *)([Gemini shared].viewController)).displayType) {
        case GEM_IPHONE:
            rval = fileName;
            break;
        case GEM_IPHONE_RETINA:
            rval = [[base stringByAppendingString:@"@retina"] stringByAppendingString:suffix];
            break;
        case GEM_IPHONE_5:
            break;
        case GEM_IPAD:
            break;
        case GEM_IPAD_RETINA:
            break;
        default:
            rval = fileName;
            break;
    }
    
    
    return rval;
}*/

@end
