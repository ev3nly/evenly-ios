//
//  EVNavigationController.m
//  Evenly
//
//  Created by Justin Brunet on 8/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationController.h"

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
	// Do any additional setup after loading the view.
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
