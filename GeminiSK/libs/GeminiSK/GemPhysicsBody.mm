//
//  GemPhysicsBody.m
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemPhysicsBody.h"
#import "Gemini.h"
#include "Box2D.h"

@interface GemPhysicsBody () {
}
@end

@implementation GemPhysicsBody

-(id)init {
    self = [super init];
    if (self) {
        self.body = NULL;
    }
    
    return self;
}


@end
