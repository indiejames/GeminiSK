//
//  GemCollisionEvent.h
//  GeminiSDK
//
//  Created by James Norton on 11/29/12.
//
//

#import "GemEvent.h"

#define GEM_COLLISION_EVENT_LUA_KEY "Gemini.GemCollisionEventLuaKey"

typedef enum GemCollisionPhase {
    GEM_COLLISION_PRESOLVE,
    GEM_COLLISION_POSTSOLVE
} GemCollisionPhase;

@interface GemCollisionEvent : GemEvent

@property (nonatomic) GemCollisionPhase phase;
@end
