//
//  GemAction.h
//  GeminiSK
//
//  Created by James Norton on 8/15/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GemLoadListener.h"

@interface GemAction : NSObject <GemLoadListener>

@property SKAction *skAction;
@property NSMutableDictionary *userData;
@property NSArray *resources;
@property BOOL isLoaded;

@end
