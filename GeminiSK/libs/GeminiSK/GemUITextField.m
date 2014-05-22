//
//  GemUITextField.m
//  GeminiSK
//
//  Created by James Norton on 5/19/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemUITextField.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "LGeminiEvent.h"
#import "Gemini.h"
#import "GemSKScene.h"

@implementation GemUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(BOOL)callMethodOnSelf:(NSString *)methodStr {
    BOOL rval = NO;
    
    const char *method = [methodStr cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    GemObjectWrapper *luaData = [self.userData objectForKey:@"LUA_DATA"];
    lua_State *L = luaData.L;
    
    // get the top of the stack so we can clear the items we've added when we are done
    int top = lua_gettop(L);
    
    // push our attached Lua object's userdata onto the stack
    lua_rawgeti(L, LUA_REGISTRYINDEX, luaData.propertyTableRef);
    
    // retrieve our method from the property table
    lua_getfield(L, -1, method);
    
    if (lua_isfunction(L, -1)) {
        //GemLog(@"Event handler is a function");
        // load the stacktrace printer for our error function
        int base = lua_gettop(L);  // function index
        lua_pushcfunction(L, traceback);  // push traceback function for error handling
        lua_insert(L, base);
        
        // make this object the first argument to the function
        lua_rawgeti(L, LUA_REGISTRYINDEX, luaData.selfRef);
        
        // call our method
        int err = lua_pcall(L, 1, LUA_MULTRET, -3);
        if (err != 0) {
            const char *msg = lua_tostring(L, -1);
            NSLog(@"Error executing method: %s", msg);
        }
        
        rval = YES;
    }
    
    lua_pop(L, lua_gettop(L) - top);
    
    [Gemini shared].director.activeScene = nil;
    
    return rval;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self callMethodOnSelf:@"returnPressed"]) {
        [self resignFirstResponder];
    }
    
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
