//
//  GemDirector.h
//  GeminiSDK
//
//  Created by James Norton on 8/17/12.
//
//  This class manages GemScenes 
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GemObjectWrapper.h"
#import "GemSKScene.h"

@interface GemDirector : NSObject {
    NSMutableDictionary *scenes;
    GemSKScene *currentScene;  // the current scene used for rendering
    NSMutableSet *loadingScenes;
    GemObjectWrapper *luaData;
}

@property GemSKScene *activeScene; // the scene that is currently having Lua code called against it, for initialization or other event handling
@property float sceneWidth;
@property float sceneHeight;

-(void)loadScene:(NSString *)sceneName;
-(void)gotoScene:(NSString *)scene withOptions:(NSDictionary *)options;
-(GemSKScene *)currentScene;
-(BOOL)doPendingSceneTransition;
-(void)destroyScene:(NSString *)sceneName;

-(id)initWithLuaState:(lua_State *)luaState;


@end

#define TRANSITION_TYPE_KEY @"transition_type"
#define CI_FILTER_TYPE @"CIFilter"
#define CI_FILTER_NAME @"filter_name"
#define FILTER_PARAMS_KEY @"filter_params"
#define DURATION_KEY @"duration"
