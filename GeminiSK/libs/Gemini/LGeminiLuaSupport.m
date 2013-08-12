//
//  LGeminiLuaSupport.m
//  Gemini
//
//  Created by James Norton on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGeminiLuaSupport.h"
#import "GemNode.h"

NSLock *globalLuaLock;

void createMetatable(lua_State *L, const char *key, const struct luaL_Reg *funcs){
    luaL_newmetatable(L, key);    
    lua_pushvalue(L, -1); // duplicates the metatable
    luaL_setfuncs(L, funcs, 0);
}


// generic new index method for userdata types
/*int genericNewIndex(lua_State *L){
    
    lua_getuservalue( L, -3 );  // table attached is attached to objects via user value
    lua_pushvalue(L, -3);
    lua_pushvalue(L,-3);
    lua_rawset( L, -3 );
    
    return 0;
}*/

int genericNodeIndex(lua_State *L, SKNode *obj){
    if (lua_isstring(L, -1)) {
        
        const char *key = lua_tostring(L, -1);
        if (strcmp("alpha", key) == 0){
            GLfloat alpha = obj.alpha;
            lua_pushnumber(L, alpha);
            return 1;
            
        } else if (strcmp("x", key) == 0){
            GLfloat x = obj.position.x;
            lua_pushnumber(L, x);
            return 1;
        } else if (strcmp("y", key) == 0){
            GLfloat y = obj.position.y;
            lua_pushnumber(L, y);
            return 1;
        }else if (strcmp("zRotation", key) == 0) {
            
            GLfloat rot = obj.zRotation;
            lua_pushnumber(L, rot);
            return 1;
            
        } else if (strcmp("name", key) == 0){
            NSString *name = obj.name;
            lua_pushstring(L, [name UTF8String]);
            return 1;
        } else {
            return genericIndex(L);
        }
        
    }
    
    return 0;

}



// generic new index method for userdata types
int genericNodeNewIndex(lua_State *L, SKNode *obj){
    
    if (lua_isstring(L, 2)) {
        
        if (obj != NULL) {
            const char *key = lua_tostring(L, 2);
            if (strcmp("x", key) == 0) {
                
                GLfloat x = luaL_checknumber(L, 3);
                CGPoint pos = obj.position;
                pos.x = x;
                obj.position = pos;
                
                return 0;
                
            } else if (strcmp("y", key) == 0) {
                
                GLfloat y = luaL_checknumber(L, 3);
                CGPoint pos = obj.position;
                pos.y = y;
                obj.position = pos;

                /*if ((*obj).physicsBody) {
                    // if this is a physics object then change the physics body too
                    GLKVector3 trans = GLKVector3Make((*obj).x, y, (*obj).rotation);
                    [*obj setPhysicsTransform:trans];
                }*/
                return 0;
                
            } else if (strcmp("zRotation", key) == 0) {
                
                GLfloat rot = luaL_checknumber(L, 3);
                obj.zRotation = rot;
                return 0;
                
            } else if (strcmp("xScale", key) == 0){
                GLfloat xScale = luaL_checknumber(L, 3);
                [obj setXScale:xScale];
                
                return 0;
                
            } else if (strcmp("yScale", key) == 0){
                GLfloat yScale = luaL_checknumber(L, 3);
                [obj setYScale:yScale];
                return 0;
                
            } else if (strcmp("alpha", key) == 0){
                GLfloat alpha = luaL_checknumber(L, 3);
                [obj setAlpha:alpha];
                return 0;
                
            } else if (strcmp("name", key) == 0){
                
                const char *valCStr = lua_tostring(L, 3);
                //GemLog(@"Setting object name to %s", valCStr);
                obj.name = [NSString stringWithUTF8String:valCStr];
            } else {
                return genericNewIndex(L);
            }
        }
        
        // defualt to storing value in attached lua table
        return genericNewIndex(L);
        
    } 
    
    
    
    return 0;
    
}
/*
int isObjectTouching(lua_State *L){
    __unsafe_unretained GemDisplayObject **displayObjA = (__unsafe_unretained GemDisplayObject **)lua_touserdata(L, 1);
    __unsafe_unretained GemDisplayObject **displayObjB = (__unsafe_unretained GemDisplayObject **)lua_touserdata(L, 2);
    
    bool isTouching = false;
    
    NSArray *touching = [*displayObjA getTouchingObjects];
    GemLog(@"touching %d objects", [touching count]);
    if ([touching containsObject:*displayObjB]) {
        isTouching = true;
    }
    
    lua_pushboolean(L, isTouching);
    
    return 1;
    
    
}

int removeSelf(lua_State *L){
    __unsafe_unretained GemDisplayObject **displayObj = (__unsafe_unretained GemDisplayObject **)lua_touserdata(L, -1);
    [(*displayObj).parent remove:*displayObj];
    
    return 0;
}

int genericDelete(lua_State *L){
    __unsafe_unretained GemDisplayObject  **obj = (__unsafe_unretained GemDisplayObject **)lua_touserdata(L, -1);
    GemLog(@"LGeminiSupport: deleting display object %@", (*obj).name);
    
    [(*obj).parent remove:*obj];
    [*obj delete];
    
    return 0;
}


// this method is only here to allow checks to see if Lua is properly GC'ing objects
// it doesn't actually do anything - all the action is in the various delete methods
int genericGC (lua_State *L){
    //GemRectangle  **rect = (GemRectangle **)luaL_checkudata(L, 1, GEMINI_RECTANGLE_LUA_KEY);
    
    GemLog(@"GARBAGE COLLECTED => LGeminiSupport: GC called for dipslay object");
    
    
    return 0;
}
 */

// Add a child node to the given node
int addChild(lua_State *L) {
    // stack: 1 - parent object, 2 - child object
    __unsafe_unretained GemObject **parent = (__unsafe_unretained GemObject **)lua_touserdata(L, 1);
    __unsafe_unretained GemObject **child = (__unsafe_unretained GemObject **)lua_touserdata(L, 2);
    
    SKNode *parentNode = (SKNode *)(*parent).delegate;
    SKNode *childNode = (SKNode *)(*child).delegate;
    
    [parentNode addChild:childNode];
    
    return 0;
}

// used to set common defaults for all display objects
// this function expects a table to be the top item on the stack
void setDefaultValues(lua_State *L) {
    assert(lua_type(L, -1) == LUA_TTABLE);
    lua_pushstring(L, "x");
    lua_pushnumber(L, 0);
    lua_settable(L, -3);
    
    lua_pushstring(L, "y");
    lua_pushnumber(L, 0);
    lua_settable(L, -3);
    
    lua_pushstring(L, "xOrigin");
    lua_pushnumber(L, 0);
    lua_settable(L, -3);
    
    lua_pushstring(L, "yOrigin");
    lua_pushnumber(L, 0);
    lua_settable(L, -3);
    
    lua_pushstring(L, "xReference");
    lua_pushnumber(L, 0);
    lua_settable(L, -3);
    
    lua_pushstring(L, "yReference");
    lua_pushnumber(L, 0);
    lua_settable(L, -3);
    
}

// generic init method
void setupObject(lua_State *L, const char *luaKey, GemObject *obj){
    
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
