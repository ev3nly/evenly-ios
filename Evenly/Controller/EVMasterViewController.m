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
#import "EVNavigationManager.h"

@interface EVMasterViewController ()

@property (nonatomic, strong) NSURL *killswitchURL;
@property (nonatomic, strong) UIAlertView *killswitchAlertView;

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
    UIImage *image = [UIImage imageNamed:@"Hamburger"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleLeftPanel:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.showsTouchWhenHighlighted = YES;
    
    CGSize insetSize = CGSizeMake(EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - image.size.width, (EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - image.size.height)/2);
    [button setImageEdgeInsets:UIEdgeInsetsMake(insetSize.height, 0, insetSize.height, insetSize.width)];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

- (void)showOnboardingControllerWithCompletion:(void (^)(void))completion animated:(BOOL)animated {
    EVOnboardingViewController *controller = [[EVOnboardingViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:controller animated:animated completion:completion];
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
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:signInViewController];
    [self presentViewController:navController animated:animated completion:completion];
}

#pragma mark - PIN Controller

- (void)showPINViewControllerAnimated:(BOOL)animated {
    EVEnterPINViewController *pinViewController = [[EVEnterPINViewController alloc] init];
    pinViewController.canDismissManually = NO;
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:pinViewController];
    [self presentViewController:navController animated:animated completion:nil];
}

- (void)signOutDueToFailedAttempts {
    [self dismissViewControllerAnimated:YES completion:^{
        [EVSession signOutWithSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedOutNotification object:nil];
            [self showOnboardingControllerWithCompletion:^{
                [self setCenterPanel:[[EVNavigationManager sharedManager] homeViewController]];
            } animated:YES];
        } failure:^(NSError *error) {
            DLog(@"Error: %@", error);
        }];
    }];
}

#pragma mark - Killswitch
- (void)showKillswitchWithTitle:(NSString *)title message:(NSString *)message urlString:(NSString *)urlString {
    if (!self.killswitchAlertView)
    {
        NSString *buttonString = nil;
        if (urlString) {
            self.killswitchURL = [NSURL URLWithString:urlString];
            buttonString = @"OK";
        }
        
        self.killswitchAlertView = [[UIAlertView alloc] initWithTitle:title
                                                              message:message
                                                             delegate:self
                                                    cancelButtonTitle:buttonString
                                                    otherButtonTitles:nil];
        [self.killswitchAlertView show];
    }
}

- (void)dismissKillswitch {
    [self.killswitchAlertView dismissWithClickedButtonIndex:0 animated:YES];
    self.killswitchAlertView = nil;
    self.killswitchURL = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.killswitchURL) {
        [[UIApplication sharedApplication] openURL:self.killswitchURL];
        self.killswitchAlertView = nil;
        self.killswitchURL = nil;
    }
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
