//
//  EVMasterViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "JASidePanelController.h"

@interface EVMasterViewController : JASidePanelController

#pragma mark - Onboarding

- (void)showOnboardingControllerWithCompletion:(void (^)(void))completion animated:(BOOL)animated;

#pragma mark - Login
- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion
									 animated:(BOOL)animated
						authenticationSuccess:(void (^)(void))success;

- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion animated:(BOOL)animated;
- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion;

#pragma mark - PIN Controller
- (void)showPINViewControllerAnimated:(BOOL)animated;

@end
