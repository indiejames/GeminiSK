//
//  GeminiEvent.h
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GemObjectWrapper.h"

#define GEMINI_EVENT_LUA_KEY "GeminiLib.GEMINI_EVENT_LUA_KEY"

@interface GemEvent : NSObject {
    GemObjectWrapper *target;  // the object receiving the event
    NSNumber *timestamp;
    NSString *name;
}

@property (nonatomic, strong) NSMutableDictionary *userData; // used to store lua data
@property (nonatomic, strong) GemObjectWrapper *target;
@property (readonly) NSNumber *timestamp;
@property (nonatomic, strong) NSString *name;

-(id)initWithTarget:(GemObjectWrapper *)target;

-(id) initWithLuaState:(lua_State *)luaState Target:(GemObjectWrapper *)trgt LuaKey:(const char *)luaKey;
-(id)initWithLuaState:(lua_State *)luaState Target:(GemObjectWrapper *)trgt;

@end