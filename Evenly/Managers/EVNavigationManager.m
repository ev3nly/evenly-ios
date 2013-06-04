//
//  EVNavigationManager.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationManager.h"

static EVNavigationManager *_sharedManager;

@interface EVNavigationManager () {
    EVHomeViewController *_homeViewController;
    EVProfileViewController *_profileViewController;
    EVInviteViewController *_inviteViewController;
    EVSettingsViewController *_settingsViewController;
}

@end

@implementation EVNavigationManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EVNavigationManager alloc] init];
    });
    return _sharedManager;
}

- (EVHomeViewController *)homeViewController {
    if (!_homeViewController)
        _homeViewController = [[EVHomeViewController alloc] init];
    return _homeViewController;
}

- (EVProfileViewController *)profileViewController {
    if (!_profileViewController)
        _profileViewController = [[EVProfileViewController alloc] init];
    return _profileViewController;
}

- (EVInviteViewController *)inviteViewController {
    if (!_inviteViewController)
        _inviteViewController = [[EVInviteViewController alloc] init];
    return _inviteViewController;
}

- (EVSettingsViewController *)settingsViewController {
    if (!_settingsViewController)
        _settingsViewController = [[EVSettingsViewController alloc] init];
    return _settingsViewController;
}

- (UIViewController *)viewControllerForMainMenuOption:(EVMainMenuOption)option {
    UIViewController *controller = nil;
    switch (option) {
        case EVMainMenuOptionHome:
            controller = self.homeViewController;
            break;
        case EVMainMenuOptionProfile:
            controller = self.profileViewController;
            break;
        case EVMainMenuOptionInvite:
            controller = self.inviteViewController;
            break;
        case EVMainMenuOptionSettings:
            controller = self.settingsViewController;
            break;
        case EVMainMenuOptionSupport:
        default:
            break;
    }
    return controller;    
}

@end
