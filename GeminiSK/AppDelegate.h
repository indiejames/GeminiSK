//
//  AppDelegate.h
//  GeminiSK
//
//  Created by James Norton on 8/5/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Gemini.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    Gemini *gemini;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SKView *skView;

- (void)viewDidLoad:(SKView *)view;

@end
