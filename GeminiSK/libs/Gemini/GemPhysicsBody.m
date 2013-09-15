//
//  GemPhysicsBody.m
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemPhysicsBody.h"

@implementation GemPhysicsBody

-(id)initWithBody:(SKPhysicsBody *)body {
    self = [super init];
    if (self) {
        self.skPhysicsBody = body;
    }
    
    return self;
}

-(void)dealloc {
    self.skPhysicsBody = nil;
    [self.userData removeAllObjects];
    self.userData = nil;
}

@end
