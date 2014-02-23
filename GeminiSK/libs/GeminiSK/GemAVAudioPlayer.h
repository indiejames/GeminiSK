//
//  GemAVAudioPlayer.h
//  GeminiSK
//
//  Created by James Norton on 2/22/14.
//  Copyright (c) 2014 James Norton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GemAVAudioPlayer : AVAudioPlayer <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary *userData;

@end
