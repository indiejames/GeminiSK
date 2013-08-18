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

SKNode *getNode(lua_State *L); // get the node from the object on the top of the Lua stack
int setPosition(lua_State *L); // used everywhere
int destroyNode(lua_State *L); //
int runAction(lua_State *L);