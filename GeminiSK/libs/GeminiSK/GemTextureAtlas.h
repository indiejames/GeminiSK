//
//  GemTextureAtlas.h
//  GeminiSK
//
//  Created by James Norton on 10/6/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GemLoadListener.h"
#import "GemLoader.h"

@interface GemTextureAtlas : NSObject <GemLoader>
@property SKTextureAtlas *atlas;
@property (readonly) Boolean isLoaded;
@property id userData;

-(id) initWithAtlasNamed:(NSString *)atlasName;

@end

#define GEMINI_TEXTURE_ATLAS_LUA_KEY "GeminiLib.GEMINI_TEXTURE_ATLAS_LUA_KEY"
