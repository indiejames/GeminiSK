//
//  GemRepeatAction.m
//  GeminiSK
//
//  Created by James Norton on 10/25/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemRepeatAction.h"

@implementation GemRepeatAction {
    GemAction *_gemAction;
    int _actionCount;
}

-(id) initWithAction:(GemAction *)action count:(int)count {
    self = [super init];
    
    if (self) {
        _gemAction = action;
        [action addLoadListener:self];
        _actionCount = count;
        
        // check to see if the sub action is already loaded
        if (action.isLoaded) {
            self.isLoaded = true;
            [self createSKAction];
        }
    }
    
    return self;
}

-(void)createSKAction {
    if (self.isLoaded) {
        SKAction *action = _gemAction.skAction;
        if (_actionCount > 0) {
            self.skAction = [SKAction repeatAction:action count:_actionCount];
        } else {
            self.skAction = [SKAction repeatActionForever:action];
        }
        
        [self notifyListeners];
        
    }
}

-(void)loadFinished:(id)object {
    [super loadFinished:object];
    
    if (self.isLoaded) {
        [self createSKAction];
    }
}

@end
