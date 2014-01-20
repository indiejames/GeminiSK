//
//  GemSKSceneDelegate.h
//  GeminiSK
//
//  Created by James Norton on 8/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@protocol GemSKSceneDelegate <NSObject>
- (void)update:(NSTimeInterval)currentTime;
- (void)willMoveFromView:(SKView *)view;
- (void)didSimulatePhysics;
- (void)didMoveToView:(SKView *)view;
- (void)didEvaluateActions;
- (void)didChangeSize:(CGSize)oldSize;

@end
