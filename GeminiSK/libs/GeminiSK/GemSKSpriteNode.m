//
//  GemSKSpriteNode.m
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemSKSpriteNode.h"
#import "Gemini.h"
#import "GemObjectWrapper.h"
#import "LGeminiLuaSupport.h"
#import "GemTouchEvent.h"

@implementation GemSKSpriteNode {
    GemTexture *gemTexture;
}

-(id) initWithGemTexture:(GemTexture *)tex {
    self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(32, 32)];
    
    if (self) {
        gemTexture = tex;
        if (tex.isLoaded) {
            [self loadFinished:tex];
        } else {
            [tex addLoadListener:self];
        }
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)loadFinished:(id)texture {
    GemLog(@"Texture data is now available for sprite %@", self.name);
    
    self.texture = gemTexture.texture;
    CGFloat width = gemTexture.texture.size.width * self.xScale;
    CGFloat height = gemTexture.texture.size.height * self.yScale;
    CGSize size = CGSizeMake(width, height);
    self.size = size;
    _isLoaded = YES;
    
}

-(BOOL)callMethodOnSprite:(NSString *)methodStr {
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
    
    return rval;
    
}

// call an event handler
-(BOOL)callHandler:(NSString *)handler forEvent:(GemEvent *)event {
    BOOL rval = NO;
    
    const char *method = [handler cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
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
        
        // add our event object as the second argument
        //GemObjectWrapper *evtLuaData = [event.userData objectForKey:@"LUA_DATA"];
        //lua_rawgeti(L, LUA_REGISTRYINDEX, evtLuaData.selfRef);
        
        createObjectAndSaveRef(L, GEM_TOUCH_EVENT_LUA_KEY, event);
        
        // call our method
        int err = lua_pcall(L, 2, LUA_MULTRET, -4);
        if (err != 0) {
            const char *msg = lua_tostring(L, -1);
            NSLog(@"Error executing handler: %s", msg);
        }
        
        rval = YES;
    }
    
    lua_pop(L, lua_gettop(L) - top);
    
    
    return rval;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if (![self callHandler:@"touchesBegan" forEvent:evt]){ // TODO - change these to call handler on parent, not super
        //[super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(![self callMethodOnSprite:@"touchesEndend"]){
        [super touchesEnded:touches withEvent:event];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(![self callMethodOnSprite:@"touchesCancelled"]){
        [super touchesCancelled:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(![self callMethodOnSprite:@"touchesMoved"]){
        [super touchesMoved:touches withEvent:event];
    }
}



@end
