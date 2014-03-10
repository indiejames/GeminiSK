//
//  SKNode+GemSKNode.h
//  GeminiSK
//
//  Created by James Norton on 3/9/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GemTouchEvent.h"

@interface SKNode (GemSKNode)

#pragma mark Touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
