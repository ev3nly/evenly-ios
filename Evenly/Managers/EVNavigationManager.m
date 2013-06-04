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
    JASidePanelController *_sidePanelController;
    
    UINavigationController *_homeViewController;
    UINavigationController *_profileViewController;
    UINavigationController *_inviteViewController;
    UINavigationController *_settingsViewController;
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

- (JASidePanelController *)sidePanelController {
    if (!_sidePanelController)
        _sidePanelController = [[JASidePanelController alloc] init];
    return _sidePanelController;
}

- (UINavigationController *)homeViewController {
    if (!_homeViewController)
        _homeViewController = [[UINavigationController alloc] initWithRootViewController:[[EVHomeViewController alloc] init]];
    return _homeViewController;
}

- (UINavigationController *)profileViewController {
    if (!_profileViewController)
        _profileViewController = [[UINavigationController alloc] initWithRootViewController:[[EVProfileViewController alloc] init]];
    return _profileViewController;
}

- (UINavigationController *)inviteViewController {
    if (!_inviteViewController)
        _inviteViewController = [[UINavigationController alloc] initWithRootViewController:[[EVInviteViewController alloc] init]];
    return _inviteViewController;
}

- (UINavigationController *)settingsViewController {
    if (!_settingsViewController)
        _settingsViewController = [[UINavigationController alloc] initWithRootViewController:[[EVSettingsViewController alloc] init]];
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
