//
//  GemTextureAtlas.m
//  GeminiSK
//
//  Created by James Norton on 10/6/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemTextureAtlas.h"
#import "GemLoadListener.h"
#import "GemLoader.h"

@implementation GemTextureAtlas {
    NSMutableArray *loadListeners;
    SKTextureAtlas *_atlas;
}

-(id) initWithAtlasNamed:(NSString *)atlasName {
    self = [super init];
    
    if (self) {
        loadListeners = [NSMutableArray arrayWithCapacity:1];
        _atlas = [SKTextureAtlas atlasNamed:atlasName];
        // load the texture in the background
        [_atlas preloadWithCompletionHandler:^{
            [NSThread sleepForTimeInterval:2.0];
            GemLog(@"Texture atlas %@ finished loading", atlasName);
            @synchronized(self) {
                _isLoaded = YES;
            }
            @synchronized(loadListeners){
                [loadListeners enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                    [obj loadFinished:self];
                }];
            }
        }];
        
    }
    
    return self;
}

-(void)addLoadListener:(id)listener {
    @synchronized(loadListeners){
        [loadListeners addObject:listener];
    }
}

@end
