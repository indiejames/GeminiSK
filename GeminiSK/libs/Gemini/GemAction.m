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
}

-(void)dealloc {
    GemLog(@"Deallocing GemAction");
    self.skAction = nil;
    [self.userData removeAllObjects];
    self.userData = nil;
}

@end
