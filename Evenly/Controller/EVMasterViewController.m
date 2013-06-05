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
