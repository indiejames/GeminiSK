//
//  GemPhysicsBody.m
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemPhysicsBody.h"
#import "Box2D.h"
#import "Gemini.h"
#import <SpriteKit/SpriteKit.h>


@implementation GemPhysicsBody

-(id)init {
    self = [super init];
    if (self) {
        self.body = NULL;
    }
    
    return self;
}

-(void)updateFromNode {
    b2Body *b = (b2Body *)(self.body);
    SKNode *node = (__bridge SKNode *)b->GetUserData();
    CGFloat scale = [[Gemini shared].director.currentScene.physics getScale];
    b2Vec2 pos = b2Vec2(node.position.x / scale, node.position.y / scale);
    CGFloat angle = node.zRotation;
    
    b->SetTransform(pos, angle);
}


@end
