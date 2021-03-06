//
//  LGeminiNode.h
//  Gemini SK
//
//  Methods that can be used by any SKNode lua type
//
//  Created by James Norton on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGeminiLuaSupport.h"

#define GEMINI_NODE_LUA_KEY "GeminiLib.GEMINI_NODE_LUA_KEY"

SKNode *getNode(lua_State *L); // get the node from the object on the top of the Lua stack
SKNode *getNodeAtIndex(lua_State *L, int index); // get a node from the object at the given index on the
                                                // Lua stack
int getPosition(lua_State *L); // used everywhere
int setPosition(lua_State *L); // used everywhere
int destroyNode(lua_State *L); //
int runAction(lua_State *L);
int removeAllActions(lua_State *L);
int addChild(lua_State *L);
int removeFromParent(lua_State *L);