//
//  GemSKScene.h
//  GeminiSK
//
//  Created by James Norton on 8/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GemSKSceneDelegate.h"
#import "GemAction.h"
#import "GemLoadListener.h"
#import "GemPhysics.h"


@interface GemSKScene : SKScene <GemSKSceneDelegate, GemLoadListener>

@property (readonly) NSArray *textureAtlases;
@property (readonly) NSArray *actions;
@property (readonly) GemPhysics *physics;

//@property (weak) id <GemSKSceneDelegate> delegate;

-(BOOL)isReady;
-(void)addAction:(GemAction *)action;

@end
