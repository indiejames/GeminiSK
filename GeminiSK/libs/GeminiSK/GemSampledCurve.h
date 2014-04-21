//
//  GemSampledCurve.h
//  GeminiSK
//
//  Created by James Norton on 4/4/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GemSampledCurve : NSObject

-(id)initWithSamples:(NSArray *)samples;

-(CGPathRef) getPath;

@end
