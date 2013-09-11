//
//  EVNavigationController.m
//  Evenly
//
//  Created by Justin Brunet on 8/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationController.h"
#import "AMBlurView.h"

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAV_AND_STATUS_BAR_BACKGROUND_HEIGHT 65
#define STATUS_BAR_BACKGROUND_ALPHA 0.5

@interface EVNavigationController ()

@end

@implementation EVNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([EVUtilities userHasIOS7]) {
        UIView *navStatusBarBackground = [[UIView alloc] initWithFrame:[self navStatusBarBackgroundFrame]];
        navStatusBarBackground.backgroundColor = [EVColor navBarOverlayColor];
        navStatusBarBackground.alpha = STATUS_BAR_BACKGROUND_ALPHA;
        [self.navigationBar insertSubview:navStatusBarBackground atIndex:0];
        
        AMBlurView *blurView = [AMBlurView new];
        blurView.frame = [self navStatusBarBackgroundFrame];
        blurView.blurTintColor = [EVColor blueColor];
        [self.navigationBar insertSubview:blurView atIndex:0];
        
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Frames

- (CGRect)navStatusBarBackgroundFrame {
    return CGRectMake(0,
                      -STATUS_BAR_HEIGHT,
                      self.view.bounds.size.width,
                      NAV_AND_STATUS_BAR_BACKGROUND_HEIGHT);
}

@end
