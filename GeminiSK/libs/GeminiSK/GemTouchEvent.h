//
//  GemTouchEvent.h
//  GeminiSK
//
//  Created by James Norton on 3/2/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemEvent.h"

#define GEM_TOUCH_EVENT_LUA_KEY "GeminiLib.GEMINI_TOUCH_EVENT_LUA_KEY"

@interface GemTouchEvent : GemEvent

-(id) initWithEvent:(UIEvent *)event;

-(NSArray *)getTouches;

@end
