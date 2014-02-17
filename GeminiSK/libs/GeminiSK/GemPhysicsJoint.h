//
//  GemPhysicsJoint.h
//  GeminiSK
//
//  Created by James Norton on 2/16/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>


#define GEMINI_PHYSICS_JOINT_LUA_KEY "GeminiLib.GEMINI_PHYSICS_JOINT_LUA_KEY"

@interface GemPhysicsJoint : NSObject

@property (nonatomic, assign) void *joint;
@property (nonatomic, strong) NSMutableDictionary *userData;

@end
