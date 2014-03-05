//
//  GemTouchEvent.m
//  GeminiSK
//
//  Created by James Norton on 3/2/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemTouchEvent.h"
#import "GemUITouch.h"

@implementation GemTouchEvent

-(id) initWithEvent:(UIEvent *)event {
    self = [super initWithEvent:event];
    
    return self;
}

-(NSArray *)getTouches {
    NSMutableArray *touches = [NSMutableArray arrayWithCapacity:[[self.event allTouches] count]];
    
    [[self.event allTouches] enumerateObjectsUsingBlock:^(id obj, BOOL *stop){
        GemUITouch *touch = [[GemUITouch alloc] initWithUITouch:(UITouch *)obj];
        
        [touches addObject:touch];
    }];
    
    return touches;
}


@end
