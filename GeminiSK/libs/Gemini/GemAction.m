//
//  GemAction.m
//  GeminiSK
//
//  Created by James Norton on 8/15/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemAction.h"

@implementation GemAction

-(void)setTimingMode:(SKActionTimingMode) mode {
    self.skAction.timingMode = mode;
    _isLoaded = NO;
    _resources = [NSMutableArray arrayWithCapacity:1];
}

-(void)loadFinished:(id)object {
    unsigned int resourceCount = [self.resources count];
    BOOL loaded = YES;
    for (int i=0; i<resourceCount; i++) {
        id resource = [self.resources objectAtIndex:i];
        if (![resource isLoaded]) {
            loaded = NO;
        }
    }
    
    _isLoaded = loaded;
}

-(void)dealloc {
    GemLog(@"Deallocing GemAction");
    self.skAction = nil;
    [self.userData removeAllObjects];
    self.userData = nil;
}

@end
