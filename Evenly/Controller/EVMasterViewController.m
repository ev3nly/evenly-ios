//
//  EVMasterViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMasterViewController.h"

@interface EVMasterViewController ()

@end

@implementation EVMasterViewController

#pragma mark - Overrides

- (UIBarButtonItem *)leftButtonForCenterPanel {
    UIImage *image = [UIImage imageNamed:@"Hamburger"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 14, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleLeftPanel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

#pragma mark - Login Controller

- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion {
    [self showLoginViewControllerWithCompletion:completion animated:YES];
}

- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion animated:(BOOL)animated {
    [self showLoginViewControllerWithCompletion:completion animated:animated authenticationSuccess:NULL];
}

- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion
									 animated:(BOOL)animated
						authenticationSuccess:(void (^)(void))success {
    
}

@end
