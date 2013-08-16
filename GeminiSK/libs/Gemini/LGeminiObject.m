//
//  LGeminiObject.m
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#import "Gemini.h"
#import "GemObject.h"
#import "LGeminiObject.h"
#import "GemTimer.h"
#import "GemEventManager.h"


/*static int newGeminiObject(lua_State *L){
    GemObject *go = [[GemObject alloc] initWithLuaState:L];
    
    __unsafe_unretained GemObject **lgo = (__unsafe_unretained GemObject **)lua_newuserdata(L, sizeof(GemObject *));
    *lgo = go;
    
    luaL_getmetatable(L, GEMINI_OBJECT_LUA_KEY);
    lua_setmetatable(L, -2);
    
    lua_newtable(L);
    lua_pushvalue(L, -1); // make a copy of the table becaue the next line pops the top value
    // store a reference to this table so our sprite methods can access it
    go.propertyTableRef = luaL_ref(L, LUA_REGISTRYINDEX);
    lua_setuservalue(L, -2);
    
    lua_pushvalue(L, -1); // make another copy of the userdata since the next line will pop it off
    go.selfRef = luaL_ref(L, LUA_REGISTRYINDEX);
    
    // create a table for the event listeners
    lua_newtable(L);
    go.eventListenerTableRef = luaL_ref(L, LUA_REGISTRYINDEX);
    
    // copy the userdata to the top of the stack
    lua_pushvalue(L, -2);
    
    GemLog(@"New GeminiObject created");
    
    // add this new object to the globall list of objects
    [[Gemini shared].geminiObjects addObject:go];
    
    return 1;
    
}*/

int genericGC(lua_State *L){
    GemLog(@"GeminiObject released");
    return 0;
}

// method called by all bindings to remove an object
int genericDestroy(lua_State *L){
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    [(*go).delegate setUserData:nil]; // this should eventually cause the object to be gc'ed
    [[Gemini shared].geminiObjects removeObject:*go];
    // TODO - remove object from parent node
    
    return 0;
}

//
// addEventListner - add an event listener/handler to an ojbect.  This handler will get called
// when the objects is notified of the event.
//  GemObjects have tables where the keys are event types and the values are other tables that
// hold events listeners.  These sub tables have the listeners as their keys and the references
// in LUA_REGISTRYINDEX as the values.  The references are used to make sure the listeners don't
// go out of scope and get GC'ed.  This allows anonymous functions to be used for event listeners.
// Listeners can be functions or tables/userdata.  If the listener is a table/userdata, it must
// contain a function of the same name as the event.
int addEventListener(lua_State *L){
    // stack: 1 - object, 2 - event name, 3 - listener (function or table)
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    const char *eventName = luaL_checkstring(L, 2);
    NSString *name = [NSString stringWithFormat:@"%s", eventName];
    
   /* if ([name isEqualToString:GEM_TIMER_EVENT_NAME]) {
        GemLog(@"Adding timer event");
    }
    
    if ([name isEqualToString:GEM_TOUCH_EVENT_NAME]) {
        // add this object to the event manager's list of touch listeners
        GemEventManager *evtManager = ((GemGLKViewController *)([Gemini shared].viewController)).eventManager;
        [evtManager addEventListener:*go forEvent:name];
    }*/
    
    // get the event handler table
    lua_rawgeti(L, LUA_REGISTRYINDEX, (*go).eventListenerTableRef);
    // get the event handlers for this event
    lua_getfield(L, -1, eventName);
    
    if (lua_istable(L, -1)) {
        // use the existing table that holds listeners for this event
        
        // push the listener to the top of the stack twice since the next operation will pop it
        lua_pushvalue(L, 3);
        lua_pushvalue(L, -1);
        // get a ref for this listener
        int ref = luaL_ref(L, LUA_REGISTRYINDEX);
        lua_pushinteger(L, ref);
        // use listener as key and ref as value for event listener table
        lua_rawset(L, -3);
    } else {
        lua_pushstring(L, eventName);
        // create a new table to hold listeners for this event
        lua_newtable(L);
        // make the new table the event table for the given event name
        lua_settable(L, -4);
        // pull our event table back out since it just popped of the stack
        lua_getfield(L, -2, eventName);
        
        // push the listener to the top of the stack twice since the next operation will pop it
        lua_pushvalue(L, 3);
        lua_pushvalue(L, -1);
        int ref = luaL_ref(L, LUA_REGISTRYINDEX);
        lua_pushinteger(L, ref);
        // add the listener to the new table as the key with the ref as the value
        lua_rawset(L, -3);
        
    }
    
    GemLog(@"LGeminiObject: Added event listener for %@ event for %@", name, (*go).name);
    
    return 0;
}

int removeEventListener(lua_State *L){
    // stack: 1 - object, 2 - event name, 3 - listener
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    const char *eventName = luaL_checkstring(L, 2);
    
    // get the event handler table
    lua_rawgeti(L, LUA_REGISTRYINDEX, (*go).eventListenerTableRef);
    // get the event handlers for this event
    lua_getfield(L, -1, eventName);
    
    if (lua_istable(L, -1)) {
        // set a nil value for our listener key to delete the entry in our table
        // push the listener to the top of the stack
        lua_pushvalue(L, 3);
        lua_pushnil(L);
        lua_settable(L, -3);
    } else {
        luaL_error(L, "Object does not handle event %s", eventName);
        /*lua_pushstring(L, eventName);
        // create a new table to hold listeners for this event
        lua_newtable(L);
        lua_settable(L, -4);
        lua_getfield(L, -2, eventName);
        lua_pushinteger(L, 1);
        // push the listener to the top of the stack
        lua_pushvalue(L, 3);
        lua_settable(L, -3);*/
    }

    
    GemLog(@"LGeminiObject: Removed event listener for %s event for %@", eventName, (*go).name);
    
    
    return 0;

    
}


// generic index method for userdata types
int genericIndex(lua_State *L){
    // first check to see if the delegate object will accept the call
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    NSObject *delegate = (*go).delegate;
    
    const char *attr = luaL_checkstring(L, 2);
    
    // check to see if the delgate object can handle the call
    NSString *methodName = [NSString stringWithFormat:@"%s", attr];
   
    SEL selector = NSSelectorFromString(methodName);
    if ([delegate respondsToSelector:selector]) {
        // use the delegate object to handle the call
        NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
        const char *returnType = [sig methodReturnType];
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
        [invoke setTarget:delegate];
        
        [invoke setSelector:selector];
        [invoke invoke];
                
        if (strcmp("f", returnType) == 0){
            float fVal;
            [invoke getReturnValue:&fVal];
            lua_pushnumber(L, fVal);
            
        } else if (strcmp("i", returnType) == 0) {
            int iVal;
            [invoke getReturnValue:&iVal];
            lua_pushinteger(L, iVal);
        } else if (strcmp("u", returnType) == 0) {
            unsigned int uVal;
            [invoke getReturnValue:&uVal];
            lua_pushunsigned(L, uVal);
        } else if (strcmp("d", returnType) == 0) {
            double dVal;
            [invoke getReturnValue:&dVal];
            lua_pushnumber(L, dVal);
        } else {
            // everything else is treated as a string
            NSString *sVal;
            [invoke getReturnValue:&sVal];
            lua_pushstring(L, [sVal cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        }
        
        
    } else {

        // first check the uservalue
        lua_getuservalue( L, -2 );
        if(lua_isnil(L,-1)){
            // GemLog(@"user value for user data is nil");
        }
        lua_pushvalue( L, -2 );
        
        lua_rawget( L, -2 );
        if( lua_isnoneornil( L, -1 ) == 0 )
        {
            return 1;
        }
        
        lua_pop( L, 2 );
        
        // second check the metatable
        lua_getmetatable( L, -2 );
        lua_pushvalue( L, -2 );
        lua_rawget( L, -2 );
        
    }
    
    // nil or otherwise, we return here
    return 1;
    
}

// generic new index method, i.e., obj.something = some_value
// only support primitive types (ints, float, char *, etc.) for some_value
int genericNewIndex(lua_State *L) {
    __unsafe_unretained GemObject **go = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    NSObject *delegate = (*go).delegate;
    
    const char *attr = luaL_checkstring(L, 2);
    NSString *attrStr = [NSString stringWithFormat:@"%s", attr];
    // check to see if the delgate object can handle the call
    NSString *firstCapChar = [[attrStr substringToIndex:1] capitalizedString];
    NSString *cappedString = [attrStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    NSString *methodName = [NSString stringWithFormat:@"set%@:", cappedString];
    SEL selector = NSSelectorFromString(methodName);
    if ([delegate respondsToSelector:selector]) {
        // use the delegate object to handle the call
        NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
        const char *argType = [sig getArgumentTypeAtIndex:2];
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
        [invoke setTarget:delegate];
        NSString *sVal;
        char *cVal;
        double dVal;
        float fVal;
        int iVal;
        unsigned int uVal;
        
        if (strcmp("*", argType) == 0) {
            // char * string
            cVal = (char *)luaL_checkstring(L, 3);
            [invoke setArgument:&cVal atIndex:2];
        } else if (strcmp("f", argType) == 0){
            fVal = luaL_checknumber(L, 3);
            [invoke setArgument:&fVal atIndex:2];
        } else if (strcmp("i", argType) == 0) {
            iVal = luaL_checkinteger(L, 3);
            [invoke setArgument:&iVal atIndex:2];
        } else if (strcmp("u", argType) == 0) {
            uVal = luaL_checkunsigned(L, 3);
            [invoke setArgument:&uVal atIndex:2];
        } else if (strcmp("d", argType) == 0) {
            dVal = luaL_checknumber(L, 3);
            [invoke setArgument:&dVal atIndex:2];
        } else {
            // everything else is treated as a string
            cVal = (char *)luaL_checkstring(L, 3);
            sVal = [NSString stringWithFormat:@"%s", cVal];
            [invoke setArgument:&sVal atIndex:2];
        }
        switch (lua_type(L, 3)) {
            case LUA_TSTRING:
                
                break;
                
            default:
                
                
                break;
        }
        
        [invoke setSelector:selector];
        [invoke invoke];
        
    } else {
        // use the attache Lua table
        // this function gets called with the table on the bottom of the stack,
        // the index to assign to next, and the value to be assigned on top
        lua_getuservalue( L, -3 );  // table attached is attached to objects via user value
        lua_pushvalue(L, -3);
        lua_pushvalue(L,-3);
        lua_rawset( L, -3 );

    }
    
    return 0;
}

static const struct luaL_Reg geminiObjectLib_f [] = {
    //{"new", newGeminiObject},
    {NULL, NULL}
};

static const struct luaL_Reg geminiObjectLib_m [] = {
    {"addEventListener", addEventListener},
    {"removeEventListener", removeEventListener},
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {NULL, NULL}
};

int luaopen_geminiObjectLib (lua_State *L){
    // create the metatable and put it into the registry
    luaL_newmetatable(L, GEMINI_OBJECT_LUA_KEY);
    
    lua_pushvalue(L, -1); // duplicates the metatable
    
    
    luaL_setfuncs(L, geminiObjectLib_m, 0);
    
    // create a table/library to hold the functions
    luaL_newlib(L, geminiObjectLib_f);
    
    GemLog(@"gemini lib opened");
    
    return 1;
}