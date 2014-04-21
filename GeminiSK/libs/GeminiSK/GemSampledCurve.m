//
//  GemSampledCurve.m
//  GeminiSK
//
//  Created by James Norton on 4/4/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemSampledCurve.h"

@implementation GemSampledCurve

NSMutableArray *samples;

-(id)initWithPoints:(NSArray *)points {
    self = [super init];
    if (self) {
        samples = [NSMutableArray arrayWithArray:points];
    }
    
    return self;
}

-(void)addPoints:(NSArray *)points{
    [samples addObjectsFromArray:points];
    
}

-(CGPathRef)getPath {
    CGMutablePathRef ref = CGPathCreateMutable();
    
    for (int i=0; i < [samples count] / 4; i++) {
        NSValue *Pn1 = [samples objectAtIndex:i*4];
        NSValue *Pn2 = [samples objectAtIndex:(i*4+1)];
        NSValue *Pn3 = [samples objectAtIndex:(i*4+2)];
        NSValue *Pn4 = [samples objectAtIndex:(i*4+3)];
        CGPoint P1 = [Pn1 CGPointValue];
        CGPoint P2 = [Pn2 CGPointValue];
        CGPoint P3 = [Pn3 CGPointValue];
        CGPoint P4 = [Pn4 CGPointValue];
        
        
    }
    
    return ref;
}

@end
