//
//  GemSKSpriteNode.m
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemSKSpriteNode.h"

@implementation GemSKSpriteNode {
    GemTexture *gemTexture;
}

-(id) initWithGemTexture:(GemTexture *)tex {
    self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(32, 32)];
    
    if (self) {
        gemTexture = tex;
        [tex addLoadListener:self];
    }
    
    return self;
}

-(void)loadFinished:(id)texture {
    GemLog(@"Texture data is now available");
    
    self.texture = gemTexture.texture;
    self.size = gemTexture.texture.size;
    _isLoaded = YES;
    
}


@end
