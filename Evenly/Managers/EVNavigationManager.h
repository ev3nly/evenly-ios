//
//  EVNavigationManager.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVMainMenuViewController.h"
#import "EVHomeViewController.h"
#import "EVProfileViewController.h"
#import "EVInviteViewController.h"
#import "EVSettingsViewController.h"

@interface EVNavigationManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) UIViewController *homeViewController;
@property (nonatomic, readonly) UIViewController *profileViewController;
@property (nonatomic, readonly) UIViewController *inviteViewController;
@property (nonatomic, readonly) UIViewController *settingsViewController;

- (UIViewController *)viewControllerForMainMenuOption:(EVMainMenuOption)option;

@end