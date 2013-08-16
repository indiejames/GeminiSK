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
#import "GemObject.h"

@interface GemDirector : NSObject {
    NSMutableDictionary *scenes;
    NSMutableArray *allScenes;
    NSString *currentScene;  // the current scene used for rendering, etc.
    NSMutableSet *loadingScenes;
    GemObject *luaData;
}

-(void)loadScene:(NSString *)sceneName;
-(void)gotoScene:(NSString *)scene withOptions:(NSDictionary *)options;
-(void)setCurrentScene:(NSString *)scene;

-(id)initWithLuaState:(lua_State *)luaState;

@end
