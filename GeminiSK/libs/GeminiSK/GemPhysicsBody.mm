//
//  GemPhysicsBody.m
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemPhysicsBody.h"
#include "Box2D.h"

@interface GemPhysicsBody () {
    
    b2World *world;
    b2BodyDef bodyDef;
    b2Body *body;
    b2Fixture *fixtures;
    
}

@end

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
