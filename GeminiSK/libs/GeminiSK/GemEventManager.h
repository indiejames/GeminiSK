//
//  GemEventManager.h
//  GeminiSDK
//
//  Created by James Norton on 9/13/12.
//
//

#import <Foundation/Foundation.h>
#import "GemObjectWrapper.h"

#define GEM_TOUCH_EVENT_NAME @"touch"

@class GemGLKViewController;

@interface GemEventManager : GemObjectWrapper

@property (weak) GemGLKViewController *parentGLKViewController;

- (void)addEventListener:(GemObjectWrapper *)listener forEvent:(NSString *)event;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)setTouchFocus:(GemObjectWrapper *)focus forEvent:(GemEvent *)event;
-(void)removeTouchFocus:(GemObjectWrapper *)focus;

@end
