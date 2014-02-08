//
//  GemPhysicsBody.h
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface GemPhysicsBody : NSObject

@property SKPhysicsBody *skPhysicsBody;
@property NSMutableDictionary *userData;



@end
