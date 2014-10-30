//
//  GemLevelHelperLoader.m
//  GeminiSK
//
//  Created by James Norton on 10/27/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemLevelHelperLoader.h"

@implementation GemLevelHelperLoader

#pragma mark Utility Functions

+(UIColor *) colorFrom: (NSString *)str {
    NSRange range = NSMakeRange(0, str.length);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d\\.\\d{6}" options:0 error:nil];
    NSArray *matches = [regex matchesInString:str options:0 range:range];
    NSString *redStr = [str substringWithRange:((NSTextCheckingResult *)[matches objectAtIndex:0]).range];
    NSString *greenStr = [str substringWithRange:((NSTextCheckingResult *)[matches objectAtIndex:1]).range];
    NSString *blueStr = [str substringWithRange:((NSTextCheckingResult *)[matches objectAtIndex:2]).range];
    NSString *alphaStr = [str substringWithRange:((NSTextCheckingResult *)[matches objectAtIndex:3]).range];
    NSNumber *red =  @([redStr floatValue]);
    NSNumber *green = @([greenStr floatValue]);
    NSNumber *blue = @([blueStr floatValue]);
    NSNumber *alpha = @([alphaStr floatValue]);
    
    return [UIColor colorWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:[alpha floatValue]];
    
}

#pragma mark Loader

+(GemSKScene *)load:(NSString *) levelName {
    GemSKScene *scene = [[GemSKScene alloc] init];
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:levelName ofType:@"lhplist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSNumber *aspect = [dict valueForKey:@"aspect"];
    NSString *backgroundColorString = [dict valueForKey:@"backgroundColor"];
    UIColor *backgroundColor = [self colorFrom:backgroundColorString];
    scene.backgroundColor = backgroundColor;
    
    NSArray *children = [dict valueForKey:@"children"];
    
    [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *child = (NSDictionary *)obj;
    }];
    
    return scene;
}

@end
