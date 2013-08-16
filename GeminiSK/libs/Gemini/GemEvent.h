//
//  GeminiEvent.h
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GemObject.h"

#define GEMINI_EVENT_LUA_KEY "GeminiLib.GEMINI_EVENT_LUA_KEY"

@interface GemEvent : NSObject {
    GemObject *target;  // the object receiving the event
    NSNumber *timestamp;
    NSString *name;
}

@property (nonatomic, strong) NSMutableDictionary *userData; // used to store lua data
@property (nonatomic, strong) GemObject *target;
@property (readonly) NSNumber *timestamp;
@property (nonatomic, strong) NSString *name;

-(id)initWithTarget:(GemObject *)target;

-(id) initWithLuaState:(lua_State *)luaState Target:(GemObject *)trgt LuaKey:(const char *)luaKey;
-(id)initWithLuaState:(lua_State *)luaState Target:(GemObject *)trgt;

@end