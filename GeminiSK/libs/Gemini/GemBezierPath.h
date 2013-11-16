//
//  GemBezierPath.h
//  GeminiSK
//
//  Created by James Norton on 11/14/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GemBezierPath : NSObject

@property (readonly) UIBezierPath *path;

-(id)initWithNum:(int) num Points:(CGPoint *)points;

@end
