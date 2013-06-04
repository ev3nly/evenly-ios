//
//  EVNavigationManager.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVMenuViewController.h"
#import "EVHomeViewController.h"
#import "EVProfileViewController.h"
#import "EVInviteViewController.h"
#import "EVSettingsViewController.h"

@interface EVNavigationManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) EVHomeViewController *homeViewController;
@property (nonatomic, readonly) EVProfileViewController *profileViewController;
@property (nonatomic, readonly) EVInviteViewController *inviteViewController;
@property (nonatomic, readonly) EVSettingsViewController *settingsViewController;

- (UIViewController *)viewControllerForMainMenuOption:(EVMainMenuOption)option;

@end
