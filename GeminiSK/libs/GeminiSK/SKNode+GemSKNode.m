//
//  SKNode+GemSKNode.m
//  GeminiSK
//
//  Created by James Norton on 3/9/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "SKNode+GemSKNode.h"
#import "LGeminiEvent.h"

@implementation SKNode (GemSKNode)

#pragma mark Touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if (!callEventHandler(self, @"touchesBegan", evt)){
        if(self.parent) {
            // bubble up the tree until someone handles the event
            [self.parent touchesBegan:touches withEvent:event];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if(!callEventHandler(self, @"touchesEnded", evt)){
        if(self.parent) {
            // bubble up the tree until someone handles the event
            [self.parent touchesEnded:touches withEvent:event];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if(!callEventHandler(self, @"touchesCancelled", evt)){
        if(self.parent) {
            // bubble up the tree until someone handles the event
            [self.parent touchesCancelled:touches withEvent:event];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if(!callEventHandler(self, @"touchesMoved", evt)){
        if(self.parent) {
            // bubble up the tree until someone handles the event
            [self.parent touchesMoved:touches withEvent:event];
        }
    }
    
}

@end
