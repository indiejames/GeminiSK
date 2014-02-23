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

@implementation GemSKSpriteNode {
    GemTexture *gemTexture;
}

-(id) initWithGemTexture:(GemTexture *)tex {
    self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(32, 32)];
    
    if (self) {
        gemTexture = tex;
        [tex addLoadListener:self];
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

-(void)callMethodOnSprite:(NSString *)methodStr {
    
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
    }
    
    lua_pop(L, lua_gettop(L) - top);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self callMethodOnSprite:@"touchesBegan"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self callMethodOnSprite:@"touchesEndend"];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self callMethodOnSprite:@"touchesCancelled"];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self callMethodOnSprite:@"touchesMoved"];
}


@end
