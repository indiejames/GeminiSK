//
//  GeminiObject.m
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gemini.h"
#import "GemObject.h"
#import "GemEvent.h"
#import "GemEventManager.h"


@implementation GemObject


-(id) initWithLuaState:(lua_State *)luaState {
    self = [super init];
    if (self) {
        eventHandlers = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.L = luaState;
        self.propertyTableRef = -1;
        self.eventListenerTableRef = -1;
        self.selfRef = -1;
    }
    
    return self;
}

// NOTE - this initializer will leave the object on the top of the Lua stack  - if this method was not
// invoked (indirectly) by Lua code, then the caller MUST empty the stack to avoid leaking
// memory.  This should only matter for the handful of GemObjects that get created manually.
// This behaviour is not completely desirable, but is necessary to avoid a lot of complications.
-(id) initWithLuaState:(lua_State *)luaState LuaKey:(const char *)luaKey {
    self = [super init];
    if (self) {
        self.L = luaState;
        if (luaState) {
            // sizeof(self) should give the size of this objects pointer (I hope)
            __unsafe_unretained GemObject **lgo = (__unsafe_unretained GemObject **)lua_newuserdata(luaState, sizeof(self));
            *lgo = self;
            
            luaL_getmetatable(luaState, luaKey);
            lua_setmetatable(luaState, -2);
            
            // append a lua table to this user data to allow the user to store values in it
            lua_newtable(luaState);
            lua_pushvalue(luaState, -1); // make a copy of the table becaue the next line pops the top value
            // store a reference to this table so our object methods can access it
            self.propertyTableRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
            
            // set the table as the user value for the Lua object
            lua_setuservalue(luaState, -2);
            
            // create a table for the event listeners
            lua_newtable(luaState);
            self.eventListenerTableRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
            
            lua_pushvalue(luaState, -1); // make another copy of the userdata since the next line will pop it off
            self.selfRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
            
            // NOTE - at this point the object is on the top of the Lua stack  - if this method was not
            // invoked (indirectly) by Lua code, then the caller MUST empty the stack to avoid leaking
            // memory.  This should only matter for the handful of GemObjects that get created manually.
            // This behaviour is not completely desirable, but necessary to avoid a lot of complications.
        } else {
            self.propertyTableRef = -1;
            self.eventListenerTableRef = -1;
            self.selfRef = -1;
        }
        
    }
    
    return self;
}


-(void) dealloc {
    
#ifdef GEM_DEBUG
    int kByteCount = lua_gc(self.L, LUA_GCCOUNT, 0);
    GemLog(@"Gemini: Lua is using %d Kb", kByteCount);
#endif
    
    // release our property table so it can be GC by Lua
    if (self.propertyTableRef != -1) {
        luaL_unref(self.L, LUA_REGISTRYINDEX, self.propertyTableRef);
    }
    
    // release our event listener/handler table so it can by GC by Lua
    if (self.eventListenerTableRef != -1) {
        luaL_unref(self.L, LUA_REGISTRYINDEX, self.eventListenerTableRef);
    }
    
    
    // release our reference to ourself so we can be GC by Lua
    if (self.selfRef != -1) {
        luaL_unref(self.L, LUA_REGISTRYINDEX, self.selfRef);
    }

#ifdef GEM_DEBUG
    kByteCount = lua_gc(self.L, LUA_GCCOUNT, 0);
    //lua_gc(self.L, LUA_GCCOLLECT, 0);
    lua_settop(self.L, 0);
    GemLog(@"Gemini: Lua is NOW using %d Kb", kByteCount);
#endif
    
}


-(BOOL)handleEvent:(GemEvent *)event {
    
    if ([event.name isEqualToString:@"applicationWillEXit"]) {
        GemLog(@"GemObject: handling event %@", event.name);
        
    }
    
    BOOL rval = NO;

    // get the full event handler table
    lua_rawgeti(self.L, LUA_REGISTRYINDEX, self.eventListenerTableRef);
    // get the event handlers for this event
    lua_getfield(self.L, -1, [event.name UTF8String]);
    // call all the listeners
    if (!lua_isnil(self.L, -1)) {
        lua_pushnil(self.L); // start at first key in table
        while(lua_next(self.L, -2) != 0){
            // key is at -2, value (lua ref) is at -1
            // get the function/table using the ref
            int ref = lua_tointeger(self.L, -1);
            lua_rawgeti(self.L, LUA_REGISTRYINDEX, ref);
            
            if (lua_isfunction(self.L, -1)) {
                //GemLog(@"Event handler is a function");
                // load the stacktrace printer for our error function
                int base = lua_gettop(self.L);  // function index
                lua_pushcfunction(self.L, traceback);  // push traceback function for error handling
                lua_insert(self.L, base);  // put it under callback function
                
                // push the event object onto the top of the stack as the argument to the event handler
                GemObject *obj = [event.userData objectForKey:@"LUA_DATA"];
                int eRef = obj.selfRef;
                lua_rawgeti(self.L, LUA_REGISTRYINDEX, eRef);
                int err = lua_pcall(self.L, 1, LUA_MULTRET, -3);
                if (err != 0) {
                    const char *msg = lua_tostring(self.L, -1);
                    NSLog(@"Error executing event handler: %s", msg);
                } else {
                    int numResp = lua_gettop(self.L) - base;
                    if (numResp == 1) {
                        // if any of the handlers return true then we will as well
                        if (lua_toboolean(self.L, -1)) {
                            rval = YES;
                            //GemLog(@"Event handler function returned YES");
                        }
                    }
                }
                         
                // leave the key on the stack for the next iteration
                lua_pop(self.L, lua_gettop(self.L) - base + 2);
                
            } else { // table or user data
                BOOL userData = NO;
                if (lua_isuserdata(self.L, -1)) {
                    // methods on a userdata expect the userdata to be the first argument
                    userData = YES;
                }
                
                const char *ename = [event.name UTF8String];
                                                
                int base = lua_gettop(self.L);  /* table index */
                lua_pushcfunction(self.L, traceback);  /* push traceback function */
                lua_insert(self.L, base);  /* put handler above traceback function */
                
                lua_getfield(self.L, -1, ename);
                
                if (userData) {
                    // need to push the userdata on the stack since the function will expect it as
                    // the first argument
                    lua_pushvalue(self.L, -2);
                }
                GemObject *obj = [event.userData objectForKey:@"LUA_DATA"];
                int eRef = obj.selfRef;
                lua_rawgeti(self.L, LUA_REGISTRYINDEX, eRef); // add the event as the second param
                
                int err = 0;
                if (userData) {
                    err = lua_pcall(self.L, 2, LUA_MULTRET, -5);
                } else {
                    err = lua_pcall(self.L, 1, LUA_MULTRET, -4);
                }
                
                if (err != 0) {
                    const char *msg = lua_tostring(self.L, -1);
                    GemLog(@"Error executing event handler: %s", msg);
                } else {
                    
                    int numResp = lua_gettop(self.L) - base - 1;
                    if (numResp == 1) {
                        // if any of the handlers return true then we will as well
                        if (lua_toboolean(self.L, -1)) {
                            rval = YES;
                            GemLog(@"Event handler returned YES");
                        }
                    }

                }
                                
                int pop = lua_gettop(self.L) - base + 2;
                
                lua_pop(self.L, pop);
            }
            
            
        }

    }
        
    return rval;
}

@end

