//
//  GemCollisionEvent.h
//  GeminiSDK
//
//  Created by James Norton on 11/29/12.
//
//

#import "GemEvent.h"
#import <SpriteKit/SpriteKit.h>

#define GEM_COLLISION_EVENT_LUA_KEY "Gemini.GemCollisionEventLuaKey"

@interface GemCollisionEvent : GemEvent

@property SKNode *nodeA;
@property SKNode *nodeB;
@property NSString *phase;

@end
