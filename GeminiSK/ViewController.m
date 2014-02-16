//
//  ViewController.m
//  GeminiSK
//
//  Created by James Norton on 8/5/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) viewDidLoad:skView];
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // capture our width and height
    CGRect bounds = self.view.bounds;
    float screenScale = [[UIScreen mainScreen] scale];
    bounds.size.height = bounds.size.height*screenScale;
    bounds.size.width = bounds.size.width*screenScale;
    [Gemini shared].director.sceneHeight = bounds.size.height;
    [Gemini shared].director.sceneWidth = bounds.size.width;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
