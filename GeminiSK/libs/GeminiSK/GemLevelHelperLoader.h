//
//  GemLevelHelperLoader.h
//  GeminiSK
//
//  Created by James Norton on 10/27/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GemSKScene.h"

@interface GemLevelHelperLoader : NSObject

+(GemSKScene *)load:(NSString *) levelName;

@end
