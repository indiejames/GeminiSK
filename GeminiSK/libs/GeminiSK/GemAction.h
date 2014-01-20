//
//  GemAction.h
//  GeminiSK
//
//  Created by James Norton on 8/15/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GemLoadListener.h"
#import "GemLoader.h"

@interface GemAction : NSObject <GemLoadListener, GemLoader>

@property SKAction *skAction;
@property NSMutableDictionary *userData;
@property NSMutableArray *resources;
@property BOOL isLoaded;

-(void)notifyListeners;

@end
