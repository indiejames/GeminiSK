//
//  GemLoader.h
//  GeminiSK
//
//  Created by James Norton on 10/7/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GemLoadListener.h"

@protocol GemLoader <NSObject>

-(void)addLoadListener:(id)listener;

@end
