//
//  GemSpriteAnimationAction.m
//  GeminiSK
//
//  Created by James Norton on 10/13/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemSpriteAnimationAction.h"
#import <SpriteKit/SpriteKit.h>
#import "GemTexture.h"

@implementation GemSpriteAnimationAction {
    //SKAction *skAction;
    NSTimeInterval timePerFrame;
    NSMutableArray *frames;
    BOOL _isInitialized;
}

-(id) initWithTextures:(NSArray *)textures timePerFrame:(NSTimeInterval) tpf {
    self = [super init];
    if (self) {
        _isInitialized = NO;  // TODO - need to add syncrhonization here
        
        frames = [NSMutableArray arrayWithArray:textures];
        for (int i=0; i< [textures count]; i++) {
            GemTexture *tex = [textures objectAtIndex:i];
            [tex addLoadListener:self];
            [self.resources addObject:tex];
        }
        
        // check to see if everything has already loaded and init our SKAction if everything has
        BOOL allLoaded = YES;
        for (int i=0; i<[self.resources count]; i++) {
            GemTexture *tex = [self.resources objectAtIndex:i];
            if (!tex.isLoaded) {
                allLoaded = NO;
                break;
            }
        }
        
        timePerFrame = tpf;
        
        self.isLoaded = allLoaded;
        
        if (allLoaded) {
            [self handleLoadFinished];
        }
        
        _isInitialized = YES;
    }
    
    return self;
}

-(void)handleLoadFinished {
    if (self.isLoaded) {
        // create the SKAnimation action
        NSMutableArray *skTextures = [NSMutableArray arrayWithCapacity:[frames count]];
        for (int i=0; i<[frames count]; i++) {
            GemTexture *tex = [frames objectAtIndex:i];
            [skTextures addObject:tex.texture];
        }
        
        self.skAction = [SKAction animateWithTextures:skTextures timePerFrame:timePerFrame];
        
        [self notifyListeners];
    }
}

-(void)loadFinished:(id)object {
    if (_isInitialized) {  // frames vs. resources ????
        [super loadFinished:object];
        
        
        
        if (self.isLoaded) {
            [self handleLoadFinished];
        }
    }
}

@end
