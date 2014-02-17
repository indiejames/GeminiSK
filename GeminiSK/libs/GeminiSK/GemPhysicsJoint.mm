//
//  GemPhysicsJoint.m
//  GeminiSK
//
//  Created by James Norton on 2/16/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemPhysicsJoint.h"
#import "Box2D.h"

@implementation GemPhysicsJoint {
    
}

-(id)init {
    self = [super init];
    if (self) {
        self.joint = NULL;
    }
    
    return self;
}

-(float)angle {
    return ((b2RevoluteJoint *)self.joint)->GetJointAngle();
}

-(float)speed {
    return ((b2RevoluteJoint *)self.joint)->GetJointSpeed();
}

-(void)setMaxMotorTorque:(float)torque {
    ((b2RevoluteJoint *)self.joint)->SetMaxMotorTorque(torque);
}

-(void)setMotorSpeed:(float)speed {
    ((b2RevoluteJoint *)self.joint)->SetMotorSpeed(speed);
}

@end
