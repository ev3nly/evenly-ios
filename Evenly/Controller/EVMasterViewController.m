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

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(signOutDueToFailedAttempts)
                                                     name:EVPINUtilityTooManyFailedAttemptsNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Overrides

- (UIBarButtonItem *)leftButtonForCenterPanel {
    UIImage *image = nil;
#if EV_MAKE_EVERYTHING_GREEN
    image = [UIImage imageNamed:@"Green_Hamburger"];
#else 
    image = [UIImage imageNamed:@"Hamburger"];
#endif
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

- (void)signOutDueToFailedAttempts {
    [self dismissViewControllerAnimated:YES completion:^{
        [EVSession signOutWithSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedOutNotification object:nil];
            [self showLoginViewControllerWithCompletion:nil
                                               animated:YES
                                  authenticationSuccess:^{
                                  } ];
        } failure:^(NSError *error) {
            DLog(@"Error: %@", error);
        }];
    }];
}

@end
