//
//  GemSKTexture.h
//  GeminiSK
//
//  Created by James Norton on 10/2/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GemLoadListener.h"
#import "GemLoader.h"
#import "GemTextureAtlas.h"

@interface GemTexture : NSObject <GemLoadListener, GemLoader>
@property (readonly) SKTexture *texture;
@property (readonly) GemTextureAtlas *atlas;
@property (readonly) NSString *imageName;
@property (readonly) BOOL isLoaded;
@property id userData;

-(id) initWithImageNamed:(NSString *) name textureAtlas:(GemTextureAtlas *) atlas;

@end
