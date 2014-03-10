//
//  LGeminiEvent.h
//  Gemini
//
//  Created by James Norton on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#import "GemLuaData.h"
#import "GemEvent.h"
#import <SpriteKit/SpriteKit.h>

BOOL callEventHandler(SKNode *obj, NSString *handler, GemEvent *event);
BOOL callMethod(SKNode *obj, NSString *method);
