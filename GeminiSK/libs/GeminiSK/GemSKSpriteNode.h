//
//  GemSKSpriteNode.h
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GemLoadListener.h"
#import "GemLuaData.h"
#import "GemTexture.h"

@interface GemSKSpriteNode : SKSpriteNode <GemLoadListener, GemLuaData>
@property BOOL isLoaded;

-(id) initWithGemTexture:(GemTexture *)tex;

@end
