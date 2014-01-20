//
//  GemRepeatAction.h
//  GeminiSK
//
//  Created by James Norton on 10/25/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemAction.h"

@interface GemRepeatAction : GemAction

-(id) initWithAction:(GemAction *)action count:(int)count;

@end
