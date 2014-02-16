//
//  GemPhysicsBody.h
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GemSKScene.h"



@interface GemPhysicsBody : NSObject

@property NSMutableDictionary *userData;
@property BOOL allowsRotation;
@property float angle;
@property float angularDamping;
@property float angularVelocity;
@property uint32_t categoryBitMask;
@property uint32_t collisionBitMask;
@property uint32_t contactTestBitMask;
@property float density;
@property BOOL dynamic;
@property float friction;
@property float gravityScale;
@property float linearDamping;
@property float restitution;
@property BOOL usesPreciseCollisionDetection;

-(void)initb2BodyForNode:(SKNode *)node;
-(void)addFixture:(void *)fixtureDef;



@end
