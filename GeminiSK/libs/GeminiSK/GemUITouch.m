//
//  GemUITouch.m
//  GeminiSK
//
//  Created by James Norton on 3/2/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemUITouch.h"
#import <SpriteKit/SpriteKit.h>
#import "Gemini.h"

@implementation GemUITouch

-(id)initWithUITouch:(UITouch *)touch {
    self = [super init];
    
    if (self) {
        SKScene *scene = [[Gemini shared].director currentScene];
        
        CGPoint location = [touch locationInNode:scene];
        self.x = location.x;
        self.y = location.y;
        
        // TODO use something better than ints here
        switch (touch.phase) {
            case UITouchPhaseBegan:
                self.phase = 0;
                break;
            case UITouchPhaseCancelled:
                self.phase = 1;
                break;
            case UITouchPhaseEnded:
                self.phase = 2;
                break;
            case UITouchPhaseMoved:
                self.phase = 3;
                break;
            case UITouchPhaseStationary:
                self.phase = 3;
                break;
            default:
                self.phase = -1;
                break;
        }
        
        self.tapCount = touch.tapCount;
        self.timestamp = touch.timestamp;
    }
    
    return self;
}

@end
