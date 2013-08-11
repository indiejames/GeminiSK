//
//  LGeminiNode.m
//  Gemini SK
//
//  Created by James Norton on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGeminiNode.h"
#import "Gemini.h"

int setPosition(lua_State *L) {
    // stack - 1 - object, 2 - x, 3 - y
    // we don't check the userdata type here because it can be anything - we just force it to
    // GemObject
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    SKNode *node = (SKNode *)(*go).delegate;
    
    GLfloat x = luaL_checknumber(L, 2);
    GLfloat y = luaL_checknumber(L, 3);
    
    CGPoint pos = CGPointMake(x, y);
    node.position = pos;
    
    return 0;
}
