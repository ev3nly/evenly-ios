//
//  EVMasterViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "JASidePanelController.h"

@interface EVMasterViewController : JASidePanelController

#pragma mark - Login
- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion
									 animated:(BOOL)animated
						authenticationSuccess:(void (^)(void))success;

- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion animated:(BOOL)animated;
- (void)showLoginViewControllerWithCompletion:(void (^)(void))completion;


@end
