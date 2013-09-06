//
//  EVNavigationController.m
//  Evenly
//
//  Created by Justin Brunet on 8/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationController.h"
#import "AMBlurView.h"

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
        UIView *navStatusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 65)];
        navStatusBarBackground.backgroundColor = EV_RGB_COLOR(0, 112, 207);// [EVColor blueColor];
        navStatusBarBackground.alpha = 0.5;
        [self.navigationBar insertSubview:navStatusBarBackground atIndex:0];
        
        AMBlurView *blurView = [AMBlurView new];
        blurView.frame = CGRectMake(0, -20, 320, 65);
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

@end
