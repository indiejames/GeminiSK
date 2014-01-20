//
//  GemSpriteAnimationAction.h
//  GeminiSK
//
//  Created by James Norton on 10/13/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemAction.h"

@interface GemSpriteAnimationAction : GemAction

-(id) initWithTextures:(NSArray *)textures timePerFrame:(NSTimeInterval) tpf;

@end
