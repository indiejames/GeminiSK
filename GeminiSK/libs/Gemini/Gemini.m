//
//  Gemini.m
//  Gemini
//
//  Created by James Norton on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gemini.h"


#import "ObjectAL.h"
#import "GemEvent.h"
#import "GemObject.h"
#import "GemDirector.h"
#import "LGeminiLuaSupport.h"
//#import "GemGLKViewController.h"
//#import "GemDisplayObject.h"
//#import "LGeminiObject.h"
//#import "LGeminiDisplay.h"
//#import "GemTransitionManager.h"
//#import "GemPhysics.h"



@interface Gemini () {
@private
    lua_State *L;
    NSDictionary *settings;
    int x;
    double initTime;
    GemObject *runtime;
    GemDirector *director;
    GemTimerManager *_timerManager;
}
@end


@implementation Gemini

//@synthesize L;
@synthesize geminiObjects;
@synthesize viewController;
@synthesize initTime;
//@synthesize physics;
@synthesize fileNameResolver;
@synthesize settings;
@synthesize director;
//@synthesize soundManager;
//@synthesize fontManager;
@synthesize timerManager;

int setLuaPath(lua_State *L, NSString* path );

// add a global Runtime object
-(void) addRuntimeObject {
    
    runtime = [[GemObject alloc] initWithLuaState:L LuaKey:GEMINI_OBJECT_LUA_KEY];
    runtime.name = @"Runtime";
    
    // push the ref to the runtime object onto the lua stack
    lua_rawgeti(L, LUA_REGISTRYINDEX, runtime.selfRef);
    
    // create an entry in the lua global table
    lua_setglobal(L, "Runtime");
    
    // empty the stack
    lua_pop(L, lua_gettop(L));
    
    // make sure it doesn't get GC'ed
    [self.geminiObjects addObject:runtime];
    
}

// setup global constants related to rendering
-(void) setupGlobalConstants {
    // GL blending constants
    lua_pushinteger(L, GL_SRC_ALPHA);
    lua_setglobal(L, "GL_SRC_ALPHA");
    lua_pushinteger(L, GL_ONE_MINUS_SRC_ALPHA);
    lua_setglobal(L, "GL_ONE_MINUS_SRC_ALPHA");
    lua_pushinteger(L, GL_ONE);
    lua_setglobal(L, "GL_ONE");
    lua_pushinteger(L, GL_ZERO);
    lua_setglobal(L, "GL_ZERO");
    
    // physics draw modes
    /*lua_pushinteger(L, GEM_PHYSICS_DEBUG);
    lua_setglobal(L, "RENDER_DEBUG");
    lua_pushinteger(L, GEM_PHYSICS_NORMAL);
    lua_setglobal(L, "RENDER_NORMAL");
    lua_pushinteger(L, GEM_PHYSICS_HYBRID);
    lua_setglobal(L, "RENDER_HYBRID");*/
    
    // keyboard types
    lua_pushinteger(L, UIKeyboardTypeDefault); // Default type for the current input method.
    lua_setglobal(L,"UIKeyboardTypeDefault");
    lua_pushinteger(L, UIKeyboardTypeASCIICapable); // Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
    lua_setglobal(L,"UIKeyboardTypeASCIICapable");
    lua_pushinteger(L, UIKeyboardTypeNumbersAndPunctuation);  // Numbers and assorted punctuation.
    lua_setglobal(L,"UIKeyboardTypeNumbersAndPunctuation");
    lua_pushinteger(L, UIKeyboardTypeURL); // A type optimized for URL entry (shows . / .com prominently).
    lua_setglobal(L, "UIKeyboardTypeURL");
    lua_pushinteger(L, UIKeyboardTypeNumberPad); // A number pad (0-9). Suitable for PIN entry.
    lua_setglobal(L, "UIKeyboardTypeNumberPad");
    lua_pushinteger(L, UIKeyboardTypePhonePad); // A phone pad (1-9, *, 0, #, with letters under the numbers).
    lua_setglobal(L, "UIKeyboardTypePhonePad");
    lua_pushinteger(L, UIKeyboardTypeNamePhonePad); // A type optimized for entering a person's name or phone number.
    lua_setglobal(L, "UIKeyboardTypeNamePhonePad");
    lua_pushinteger(L, UIKeyboardTypeEmailAddress); // A type optimized for multiple email address entry (shows space @ . prominently).
    lua_setglobal(L, "UIKeyboardTypeEmailAddress");
    
    lua_settop(L, 0);
}

// setup the global error function that will print a stack trace on errors
/*-(void)registerErrorFunc {

    luaL_loadbuffer(L, errorFunc, strlen(errorFunc), "errorHandler");
    int err = lua_pcall(L, 0, 0, 0);
    if (err == 0) {
        GemLog(@"Gemini: Global error function set");
    } else {
        GemLog(@"Gemini: error setting up global error function");
    }
    lua_settop(L, 0);
}*/


- (id)init
{    
    self = [super init];
    if (self) {
        initTime = [NSDate timeIntervalSinceReferenceDate];
        float scale = [UIScreen mainScreen].scale;
        CGSize bounds = [[UIScreen mainScreen] bounds].size;
        int w = bounds.width * scale;
        int h = bounds.height * scale;
        
        NSString *localizedPath = [[NSBundle mainBundle] pathForResource:@"gemini" ofType:@"plist"];
        //NSString *myId = [NSString stringWithFormat:@"%dx%d",w,h];
        NSString *myId = [NSString stringWithFormat:@"%dx%d",w,h];
        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:localizedPath];
        
        settings = [plist objectForKey:myId];
        
        fileNameResolver = [[GemFileNameResolver alloc] initForWidth:bounds.width Height:bounds.height ContentScale:scale Settings:plist];
                
        geminiObjects = [[NSMutableArray alloc] initWithCapacity:1];
        timerManager = [[GemTimerManager alloc] init];
        //viewController = [[GeminiGLKViewController alloc] init];
        L = luaL_newstate();
        luaL_openlibs(L);
        if(lua_gc(L, LUA_GCISRUNNING, 0)){
            GemLog( @"GC is running");
        } else {
            GemLog(@"GC is NOT running");
        }
        
        
        lua_settop(L, 0);
        
        director = [[GemDirector alloc] initWithLuaState:L];
        
    }
    
    return self;
}

+(Gemini *)shared {
    static Gemini *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Gemini alloc] init];
        [singleton addRuntimeObject];
        [singleton setupGlobalConstants];
    });
        
    return singleton;
}


-(void)fireTimer {
    //GeminiEvent *event = [[GeminiEvent alloc] init];
    //event.name = @"timer";
    // TODO - finish this
    
}

-(void)execute:(NSString *)filename {
    int err;
    
	lua_settop(L, 0);
    
    lua_pushcfunction(L, traceback);
    
    NSString *resolvedFileName = [fileNameResolver resolveNameForFile:filename ofType:@"lua"];
    
    NSString *luaFilePath = [[NSBundle mainBundle] pathForResource:resolvedFileName ofType:@"lua"];
  
    setLuaPath(L, [luaFilePath stringByDeletingLastPathComponent]);
    
    err = luaL_loadfile(L, [luaFilePath cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	
	if (0 != err) {
        luaL_error(L, "cannot compile lua file: %s",
                   lua_tostring(L, -1));
		return;
	}
    
	
    err = lua_pcall(L, 0, 0, 1);
	if (0 != err) {
		luaL_error(L, "cannot run lua file: %s",
                   lua_tostring(L, -1));
		return;
	}
    
   /* NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(fireTimer) userInfo:nil repeats:YES];
    [timer retain];*/
}

/*-(BOOL)handleEvent:(NSString *)event {
    GemLog(@"Gemini handling event %@", event);
    GemEvent *ge = [[GemEvent alloc] initWithLuaState:L Target:nil Event:nil];
    ge.name = event;
    
    for (id gemObj in geminiObjects) {
        if ([(GemObject *)gemObj handleEvent:ge]) {
            
            return YES;
        }
    }
    
    
    return NO;
}*/

-(void)handleEvent:(GemEvent *)event {
    [runtime handleEvent:event];
}

-(void)sendEventToRuntime:(NSString *)evt {
    GemEvent *event = [[GemEvent alloc] initWithLuaState:L Target:runtime];
    event.name = evt;
    [runtime handleEvent:event];
}

-(void)applicationWillExit {
    [self sendEventToRuntime:@"applicationWillExit"];
}

-(void)applicationWillResignActive {
    
    [self sendEventToRuntime:@"applicationWillResignActive"];
}

- (void)applicationDidBecomeActive {
    [self sendEventToRuntime:@"applicationDidBecomeActive"];
}

-(void)applicationDidEnterBackground {
    [self sendEventToRuntime:@"applicationDidEnterBackground"];
}

-(void)applicationWillEnterForeground {
    [self sendEventToRuntime:@"applicationWillEnterForeground"];
}


// makes it possible for Lua to load files on iOS
int setLuaPath(lua_State *L, NSString* path )  
{
    lua_getglobal( L, "package" );
    lua_getfield( L, -1, "path" ); // get field "path" from table at top of stack (-1)
    NSString * cur_path = [NSString stringWithUTF8String:lua_tostring( L, -1 )]; // grab path string from top of stack
    cur_path = [cur_path stringByAppendingString:@";"]; // do your path magic here
    cur_path = [cur_path stringByAppendingString:path];
    cur_path = [cur_path stringByAppendingString:@"/?.lua"];
    cur_path = [cur_path stringByAppendingString:@";"];
    cur_path = [cur_path stringByAppendingString:path];
    cur_path = [cur_path stringByAppendingString:@"/?"];
    lua_pop( L, 1 ); // get rid of the string on the stack we just pushed on line 5
    lua_pushstring( L, [cur_path UTF8String]); // push the new one
    lua_setfield( L, -2, "path" ); // set the field "path" in table at -2 with value at top of stack
    lua_pop( L, 1 ); // get rid of package table from top of stack
    return 0; // all done!
}



@end

// global error function for Lua scripts
int traceback (lua_State *L) {
    if (!lua_isstring(L, 1))  /* 'message' not a string? */
        return 1;  /* keep it intact */
    lua_getglobal(L, "debug");
    if (!lua_istable(L, -1)) {
        lua_pop(L, 1);
        return 1;
    }
    lua_getfield(L, -1, "traceback");
    if (!lua_isfunction(L, -1)) {
        lua_pop(L, 2);
        return 1;
    }
    lua_pushvalue(L, 1);  /* pass error message */
    lua_pushinteger(L, 2);  /* skip this function and traceback */
    lua_call(L, 2, 1);  /* call debug.traceback */
    return 1;
}
