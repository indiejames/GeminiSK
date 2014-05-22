//
//  LGeminiDirector.m
//  GeminiSDK
//
//  Created by James Norton on 8/22/12.
//
//

#import <SpriteKit/SpriteKit.h>
#import "LGeminiUI.h"
#import "Gemini.h"
#import "LGeminiLuaSupport.h"
#import "AppDelegate.h"
#import "LGeminiNode.h"
#import "LGeminiObject.h"
#import "GemUITextField.h"

extern int removeEventListener(lua_State *L);
extern int addEventListener(lua_State *L);


static int newLabel(lua_State *L){
    // stack: 1 - font string
    
    GemLog(@"Creating new label");
    
    const char *fontStr = luaL_checkstring(L, 1);
     
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:[NSString stringWithFormat:@"%s", fontStr]];
    
    createObjectAndSaveRef(L, GEMINI_LABEL_LUA_KEY, label);
    
    return 1;
}

static int newTextField(lua_State *L){
    
    NSLog(@"Creating text field.");
    
    CGFloat x = luaL_checknumber(L, 1);
    CGFloat y = luaL_checknumber(L, 2);
    CGFloat width = luaL_checknumber(L, 3);
    CGFloat height = luaL_checknumber(L, 4);
    
    const char *fontStr = luaL_checkstring(L, 5);
    CGFloat fontSize = luaL_checknumber(L, 6);
    
    SKView *view = [Gemini shared].view;
    
    GemUITextField *textField = [[GemUITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    textField.font = [UIFont fontWithName:[NSString stringWithFormat:@"%s", fontStr] size:fontSize];
    
    [view addSubview:textField];
    textField.text = @"TEST TEXT";
    
    //textField.center = view.center;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor];
    /*textField.font = [UIFont systemFontOfSize:17.0];
    textField.placeholder = @"Enter your name here";*/
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    
    
    createObjectAndSaveRef(L, GEMINI_TEXTFIELD_LUA_KEY, textField);
    
    return 1;
    
}

// the mappings for the library functions
static const struct luaL_Reg uiLib_f [] = {
    {"newLabel", newLabel},
    {"destroyLabel", destroyNode},
    {"newTextField", newTextField},
    {NULL, NULL}
};

// mappings for the label methods
static const struct luaL_Reg label_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {"setPosition", setPosition},
    {"addChild", addChild},
    {"removeFromParent", removeFromParent},
    {"runAction", runAction},
    {NULL, NULL}
};

// mappings for the text field methods
static const struct luaL_Reg text_field_m [] = {
    {"__gc", genericGC},
    {"__index", genericIndex},
    {"__newindex", genericNewIndex},
    {"addEventListener", addEventListener},
    {NULL, NULL}
};

// the registration function
int luaopen_ui_lib (lua_State *L){
    // create meta tables for our various types /////////
    
    // label
    createMetatable(L, GEMINI_LABEL_LUA_KEY, label_m);
    
    // text field
    createMetatable(L, GEMINI_TEXTFIELD_LUA_KEY, text_field_m);
       
    /////// finished with metatables ///////////
    
    // create the table for this library and popuplate it with our functions
    luaL_newlib(L, uiLib_f);
    
    return 1;
}