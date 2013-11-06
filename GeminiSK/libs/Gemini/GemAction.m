//
//  GemAction.m
//  GeminiSK
//
//  Created by James Norton on 8/15/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemAction.h"

@implementation GemAction {
    NSMutableArray *_listeners;
}

-(void)setTimingMode:(SKActionTimingMode) mode {
    self.skAction.timingMode = mode;
    _isLoaded = NO;
    _resources = [NSMutableArray arrayWithCapacity:1];
    _listeners = [NSMutableArray arrayWithCapacity:1];
}

-(void)addLoadListener:(id)listener {
    [_listeners addObject:listener];
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
    
    if (loaded) {
        
        for (int i=0; i<[_listeners count]; i++) {
            id listener = [_listeners objectAtIndex:i];
            [listener loadFinished:self];
            
        }
    }
}

-(void)dealloc {
    GemLog(@"Deallocing GemAction");
    self.skAction = nil;
    [self.userData removeAllObjects];
    self.userData = nil;
}

@end
