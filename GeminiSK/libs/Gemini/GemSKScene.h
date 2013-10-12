//
//  GemSKScene.h
//  GeminiSK
//
//  Created by James Norton on 8/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GemSKSceneDelegate.h>


@interface GemSKScene : SKScene <GemSKSceneDelegate>

@property (readonly) NSMutableArray *textureAtlases;

//@property (weak) id <GemSKSceneDelegate> delegate;

-(BOOL)isReady;

@end
