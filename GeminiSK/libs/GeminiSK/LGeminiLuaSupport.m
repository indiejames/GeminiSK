//
//  LGeminiLuaSupport.m
//  Gemini
//
//  Created by James Norton on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGeminiLuaSupport.h"
#import "Gemini.h"

NSLock *globalLuaLock;

void createMetatable(lua_State *L, const char *key, const struct luaL_Reg *funcs){
    luaL_newmetatable(L, key);    
    lua_pushvalue(L, -1); // duplicates the metatable
    luaL_setfuncs(L, funcs, 0);
}

// generic init method
void setupObject(lua_State *L, const char *luaKey, GemObjectWrapper *obj){
    
    luaL_getmetatable(L, luaKey);
    lua_setmetatable(L, -2);
    
    // append a lua table to this user data to allow the user to store values in it
    lua_newtable(L);
    lua_pushvalue(L, -1); // make a copy of the table becaue the next line pops the top value
    // store a reference to this table so our object methods can access it
    obj.propertyTableRef = luaL_ref(L, LUA_REGISTRYINDEX);
    
    // add in some default values for display objects
    /*if ([obj isKindOfClass:[GemDisplayObject class]]) {
        setDefaultValues(L);
    }*/
    
    // set the table as the user value for the Lua object
    lua_setuservalue(L, -2);
    
    // create a table for the event listeners
    lua_newtable(L);
    obj.eventListenerTableRef = luaL_ref(L, LUA_REGISTRYINDEX);
    
    lua_pushvalue(L, -1); // make another copy of the userdata since the next line will pop it off
    obj.selfRef = luaL_ref(L, LUA_REGISTRYINDEX);
}

NSDictionary *tableToDictionary(lua_State *L, int stackIndex){
    NSMutableDictionary *rval = [NSMutableDictionary dictionaryWithCapacity:1];
    
    // handle negative indices correctly since pushing nil as the first key will
    // invalidate them
    if (stackIndex < 1) {
        stackIndex = lua_gettop(L) + stackIndex + 1;
    }
    
    if (lua_istable(L, stackIndex)) {
        lua_pushnil(L);  /* first key */
        while (lua_next(L, stackIndex) != 0) {
            /* uses 'key' (at index -2) and 'value' (at index -1) */
            id key;
            id value;
            switch (lua_type(L, -2)) {
                case LUA_TNUMBER:
                    key = [NSNumber numberWithDouble:lua_tonumber(L, -2)];
                    break;
                case LUA_TSTRING:
                    key = [NSString stringWithUTF8String:lua_tostring(L, -2)];
                    break;
                default:
                    break;
            }
            
            //GemLog(@"table key = %@", key);
            
            switch (lua_type(L, -1)) {
                case LUA_TNUMBER:
                    value = [NSNumber numberWithDouble:lua_tonumber(L, -1)];
                    break;
                case LUA_TSTRING:
                    value = [NSString stringWithUTF8String:lua_tostring(L, -1)];
                    break;
                case LUA_TBOOLEAN:
                    value = [NSNumber numberWithBool:lua_toboolean(L, -1)];
                    break;
                case LUA_TTABLE:
                    value = tableToDictionary(L, -1);
                    break;
                default:
                    break;
            }
            
            //GemLog(@"table value = %@", value);
            
            if (key != nil) {
                [rval setObject:value forKey:key];
            }
            
            /* removes 'value'; keeps 'key' for next iteration */
            lua_pop(L, 1);
        }
    }
    
    return rval;

}

// prevents objects from being garbage collected when Lua is still using them
void saveObjectReference(id object){
    [[Gemini shared].geminiObjects addObject:object];
}


// wraps objects in a generic type that can be used with Lua
GemObjectWrapper *createObjectWrapper(lua_State *L, const char *objectType, id object) {
    
    GemObjectWrapper *luaData = [[GemObjectWrapper alloc] initWithLuaState:L LuaKey:objectType];
    luaData.delegate = object;
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionaryWithCapacity:1];
    [wrapper setObject:luaData forKey:@"LUA_DATA"];
    [wrapper setObject:[NSString stringWithFormat:@"%s", objectType] forKey:@"LUA_TYPE"];
    [object setUserData:wrapper];
    return luaData;
}


// convenience method to help with creating objects used by Lua code
void createObjectAndSaveRef(lua_State *L, const char *objectType, id object){
    createObjectWrapper(L, objectType, object);
    saveObjectReference(object);
}

// convenience method to read a table off the stack as an NSDictionary
NSDictionary *getTableFromStack(lua_State *L, int index){ // TODO find out if I need this method AND tableFromDictionary
    NSMutableDictionary *rval = [NSMutableDictionary dictionaryWithCapacity:1];
    lua_pushnil(L);  // first key
    while (lua_next(L, index) != 0) {
        /* uses 'key' (at index -2) and 'value' (at index -1) */
        printf("%s - %s\n",
               lua_typename(L, lua_type(L, -2)),
               lua_typename(L, lua_type(L, -1)));
        const char *ckey = lua_tostring(L, -2);
        NSString *key = [NSString stringWithFormat:@"%s",ckey];
        if (lua_istable(L, -1)) {
            NSDictionary *val = getTableFromStack(L, lua_gettop(L));
            [rval setValue:val forKey:key];
        } else if (lua_isboolean(L, -1)) {
            bool bval = lua_toboolean(L, -1);
            NSNumber *val = [NSNumber numberWithBool:bval];
            [rval setValue:val forKey:key];
        } else if (lua_isnumber(L, -1)){
            double dval = luaL_checknumber(L, -1);
            NSNumber *val = [NSNumber numberWithDouble:dval];
            [rval setValue:val forKey:key];
        } else {
            // string
            const char* cval = lua_tostring(L, -1);
            [rval setValue:[NSString stringWithFormat:@"%s",cval] forKey:key];
        }
        
        /* removes 'value'; keeps 'key' for next iteration */
        lua_pop(L, 1);
    }
    
    
    return rval;
}



// mutex for Lua
void lockLuaLock(){
    if (globalLuaLock == nil){
        globalLuaLock = [[NSLock alloc] init];
    }
    
    [globalLuaLock lock];
    
}

void unlockLuaLock(){
    [globalLuaLock unlock];
}
