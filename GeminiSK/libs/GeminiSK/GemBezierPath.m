//
//  GemBezierPath.m
//  GeminiSK
//
//  Created by James Norton on 11/14/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemBezierPath.h"

@implementation GemBezierPath {
    UIBezierPath *_path;
}

// expect 3N + 1 points (1 start point plus N movements consisting of destinations plus 2 control points)
-(id) initWithNum:(int) num Points:(CGPoint *)points ClosePath:(BOOL)closePath{
    NSAssert(num % 3 == 1, @"Path must consit of 3N + 1 points");
    
    self = [super init];
    if (self) {
        _path = [UIBezierPath bezierPath];
        
        CGPoint start = points[0];
        [_path moveToPoint:start];
        
        // add each point along the path using control points
        for (int i=0; i<(num - 1)/3; i++) {
            CGPoint dest = points[i*3 + 1];
            CGPoint controlA = points[i*3 + 2];
            CGPoint controlB = points[i*3 + 3];
            [_path addCurveToPoint:dest controlPoint1:controlA controlPoint2:controlB];
        }
        
    }
    
    if (closePath) {
        [_path closePath];
    }
    
    return self;
}

    

@end
