//
//  GemNode.h
//  GeminiSK
//
//  Created by James Norton on 8/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GemObject.h"

#define GEM_NODE_KEY "GEM_NODE_KEY"

@interface GemNode : GemObject
{
    SKNode *skNode;
}

@property (readonly) SKNode *skNode;

@end
