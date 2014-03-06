//
//  GemSKSpriteNode.m
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemSKSpriteNode.h"
#import "Gemini.h"
#import "GemObjectWrapper.h"
#import "LGeminiLuaSupport.h"
#import "GemTouchEvent.h"
#import "GemLuaData.h"
#import "LGeminiEvent.h"

@implementation GemSKSpriteNode {
    GemTexture *gemTexture;
}

-(id) initWithGemTexture:(GemTexture *)tex {
    self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(32, 32)];
    
    if (self) {
        gemTexture = tex;
        if (tex.isLoaded) {
            [self loadFinished:tex];
        } else {
            [tex addLoadListener:self];
        }
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)loadFinished:(id)texture {
    GemLog(@"Texture data is now available for sprite %@", self.name);
    
    self.texture = gemTexture.texture;
    CGFloat width = gemTexture.texture.size.width * self.xScale;
    CGFloat height = gemTexture.texture.size.height * self.yScale;
    CGSize size = CGSizeMake(width, height);
    self.size = size;
    _isLoaded = YES;
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if (!callEventHandler(self, @"touchesBegan", evt)){
    //[super touchesBegan:touches withEvent:event];
        if(self.parent) {
            // TODO - figure out how to make these events bubble up - this doesn't work
            [self.parent touchesBegan:touches withEvent:event];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if(!callEventHandler(self, @"touchesEnded", evt)){
        if(self.parent) {
            // TODO - figure out how to make these events bubble up - this doesn't work
            [self.parent touchesEnded:touches withEvent:event];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if(!callEventHandler(self, @"touchesCancelled", evt)){
        if(self.parent) {
            // TODO - figure out how to make these events bubble up - this doesn't work
            [self.parent touchesCancelled:touches withEvent:event];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    GemTouchEvent *evt = [[GemTouchEvent alloc] initWithEvent:event];
    if(!callEventHandler(self, @"touchesMoved", evt)){
        if(self.parent) {
            // TODO - figure out how to make these events bubble up - this doesn't work
            [self.parent touchesMoved:touches withEvent:event];
        }
    }

}



@end
