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

#define GEMINI_PHYSICS_BODY_LUA_KEY "GeminiLib.GEMINI_PHYSICS_BODY_LUA_KEY"

@interface GemPhysicsBody : NSObject

@property (nonatomic, assign) void* body;



@end
