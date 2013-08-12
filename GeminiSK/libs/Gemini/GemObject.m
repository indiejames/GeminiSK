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
    
}


-(BOOL)handleEvent:(GemEvent *)event {
    /*if ([event.name isEqualToString:@"GEM_TIMER_EVENT"]) {
        GemLog(@"GemObject: handling event %@", event.name);

    }
    
    if ([event.name isEqualToString:GEM_TOUCH_EVENT_NAME]) {
        GemLog(@"GemObject: handling event %@", event.name);
        
    }*/
    
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
                int eRef = event.luaData.selfRef;
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
                int eRef = event.luaData.selfRef;
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

// add an event listener to this object
/*-(void)addEventListener:(int)callback forEvent:(NSString *)event {
    NSLog(@"GemObject adding event listener for %@", event);
    
    
    // get the event handler table
    lua_rawgeti(L, LUA_REGISTRYINDEX, eventListenerTableRef);
    // get the event handlers for this event
    lua_getfield(L, -1, [event UTF8String]);

    if (lua_istable(L, -1)) {
        //int index = lua_objlen(L, -1);
        //lua_pushinteger(L, index);
        lua_len(L, -1);
        lua_pushvalue(L, -4);
        lua_settable(L, -4);
    } else {
        lua_pushstring(L,[event UTF8String]);
        lua_newtable(L);
        lua_settable(L, -4);
        lua_getfield(L, -2, [event UTF8String]);
        lua_pushinteger(L, 1);
        lua_pushvalue(L, 3);
    }
}*/

// remove an event listener for this object
/*-(void)removeEventListener:(int)callback forEvent:(NSString *)event {
    GemLog(@"GemObject: removing event listener for %@", event);
    GemLog(@"GemObject: registered handlers:");
    
    NSMutableArray *handler = (NSMutableArray *)[eventHandlers objectForKey:event];
    if (handler != nil) {
        for (int i=0; i<[handler count]; i++) {
            NSNumber *h = [handler objectAtIndex:i];
            GemLog(@"\t\t%d",[h intValue]);
        }
        [handler removeObject:[NSNumber numberWithInt:callback]];
    }
}*/


@end

