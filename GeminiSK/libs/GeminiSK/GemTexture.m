//
//  GemSKTexture.m
//  GeminiSK
//
//  Created by James Norton on 10/2/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemTexture.h"
#import "GemTextureAtlas.h"

@implementation GemTexture {
    NSMutableArray *loadListeners;
}

-(id) initWithImageNamed:(NSString *) name textureAtlas:(GemTextureAtlas *) atlas {
    self = [super init];
    
    if (self) {
        loadListeners = [NSMutableArray arrayWithCapacity:1];
        @synchronized(atlas) {
            if (atlas.isLoaded) {
                _texture = [atlas.atlas textureNamed:name];
                _isLoaded = YES;
                
            } else {
                [atlas addLoadListener:self];
                _isLoaded = NO;
            }
        }
        
        _imageName = name;
        _atlas = atlas;
    }
    
    return self;
}

-(id)initWithImagenamed:(NSString *)name {
    self = [super init];
    
    if (self) {
        _isLoaded = NO;
        
        _texture = [SKTexture textureWithImageNamed:name];
        
        [_texture preloadWithCompletionHandler:^{
            //[NSThread sleepForTimeInterval:2.0];
            GemLog(@"Texture %@ finished loading", name);
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

-(id)initWithTexture:(SKTexture *)texture {
    self = [super init];
    
    if (self) {
        _texture = texture;
        [_texture preloadWithCompletionHandler:^{
            
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

-(void)loadFinished:(id)texture {
    GemLog(@"Texture data is now available for %@", _imageName);
    _texture = [_atlas.atlas textureNamed:_imageName];
    
    CGSize size = [_texture size];
    GemLog(@"Texture %@ has size %f x %f", _imageName, size.width, size.height);
    
    _isLoaded = YES;
    [loadListeners enumerateObjectsUsingBlock:^(id listener, NSUInteger index, BOOL *stop){
        [listener loadFinished:self];
    }];
}


@end
