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
	
//    UIView *navStatusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
//    navStatusBarBackground.backgroundColor = [EVColor blueColor];
//    navStatusBarBackground.alpha = 0.5;
//    [self.navigationBar insertSubview:navStatusBarBackground atIndex:0];
    
    UIView *navStatusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 65)];
    navStatusBarBackground.backgroundColor = [EVColor blueColor];
    navStatusBarBackground.alpha = 0.5;
    [self.navigationBar insertSubview:navStatusBarBackground atIndex:0];
    
    AMBlurView *blurView = [AMBlurView new];
    blurView.frame = CGRectMake(0, -20, 320, 65);
    //    blurView.frame = self.navigationController.navigationBar.bounds;
    blurView.blurTintColor = [EVColor blueColor];
    [self.navigationBar insertSubview:blurView atIndex:0];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
