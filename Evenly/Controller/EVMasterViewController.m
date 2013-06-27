//
//  EVMasterViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMasterViewController.h"
#import "EVSignInViewController.h"
#import "EVOnboardingViewController.h"
#import "EVEnterPINViewController.h"

@interface EVMasterViewController ()

@end

@implementation EVMasterViewController

#pragma mark - Overrides

- (UIBarButtonItem *)leftButtonForCenterPanel {
    UIImage *image = [UIImage imageNamed:@"Hamburger"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 14, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleLeftPanel:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

- (void)showOnboardingController {
    EVOnboardingViewController *controller = [[EVOnboardingViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:controller animated:NO completion:nil];
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
    EVSignInViewController *signInViewController = [[EVSignInViewController alloc] initWithAuthenticationSuccess:success];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
    [self presentViewController:navController animated:animated completion:completion];
}

#pragma mark - PIN Controller

- (void)showPINViewControllerAnimated:(BOOL)animated {
    EVEnterPINViewController *pinViewController = [[EVEnterPINViewController alloc] init];
    pinViewController.canDismissManually = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinViewController];
    [self presentViewController:navController animated:animated completion:nil];
}

@end
