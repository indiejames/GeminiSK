//
//  GemUITouch.h
//  GeminiSK
//
//  Created by James Norton on 3/2/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GEM_UI_TOUCH_LUA_KEY "GeminiLib.GEMINI_UI_TOUCH_LUA_KEY"

@interface GemUITouch : NSObject

@property NSMutableDictionary *userData;
@property int tapCount;
@property int phase;
@property double timestamp;
@property float x;
@property float y;

-(id)initWithUITouch:(UITouch *)touch;


@end
