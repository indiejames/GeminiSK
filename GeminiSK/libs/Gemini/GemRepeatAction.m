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
    }
    
    return self;
}

-(void)loadFinished:(id)object {
    [super loadFinished:object];
    
    if (self.isLoaded) {
        SKAction *action = _gemAction.skAction;
        self.skAction = [SKAction repeatAction:action count:_actionCount];
    }
}

@end
