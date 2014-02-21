//
//  GemBezierPath.h
//  GeminiSK
//
//  Created by James Norton on 11/14/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GEMINI_PATH_LUA_KEY "GeminiLib.GEMINI_PATH_LUA_KEY"


@interface GemBezierPath : NSObject

@property (readonly) UIBezierPath *path;
@property NSMutableDictionary *userData;

-(id)initWithNum:(int) num Points:(CGPoint *)points ClosePath:(BOOL)closePath;

@end
