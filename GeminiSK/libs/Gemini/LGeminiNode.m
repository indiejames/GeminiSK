//
//  LGeminiNode.m
//  Gemini SK
//
//  Created by James Norton on 8/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGeminiNode.h"
#import "LGeminiAction.h"
#import "Gemini.h"
#import "GemAction.h"

SKNode *getNode(lua_State *L){
    // we don't check the userdata type here because it can be anything - we just force it to
    // GemObject
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    return (SKNode *)(*go).delegate;
}

int setPosition(lua_State *L) {
    // stack - 1 - object, 2 - x, 3 - y
    SKNode *node = getNode(L);
    
    GLfloat x = luaL_checknumber(L, 2);
    GLfloat y = luaL_checknumber(L, 3);
    
    CGPoint pos = CGPointMake(x, y);
    node.position = pos;
    
    return 0;
}

int destroyNode(lua_State *L){
    SKNode *node = getNode(L);
    
    if (node) {
        [node removeFromParent];
    }
    
    //[[Gemini shared].geminiObjects removeObject:*go];

    return 0;
}

int runAction(lua_State *L){
    SKNode *node = getNode(L);
    
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)luaL_checkudata(L, 2, GEMINI_ACTION_LUA_KEY);
    
    GemAction *gemAction = (GemAction *)(*go).delegate;
    SKAction *skAction = gemAction.skAction;
    [node runAction:skAction completion:^{
        GemLog(@"Action complete");
        // allow the action wrapper to be GC'ed
        //[[Gemini shared].geminiObjects removeObject:gemAction];
    }];
    
    return 0;
}
