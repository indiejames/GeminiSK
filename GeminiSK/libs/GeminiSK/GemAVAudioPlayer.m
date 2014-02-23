//
//  GemAVAudioPlayer.m
//  GeminiSK
//
//  Created by James Norton on 2/22/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import "GemAVAudioPlayer.h"

@implementation GemAVAudioPlayer

-(id)initWithContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    self = [super initWithContentsOfURL:url error:outError];
    if (self) {
        self.delegate = self;
    }
    
    return self;
}


#pragma mark Delegate Methods

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    GemLog(@"%@ finished playing", self.url);
}

@end
