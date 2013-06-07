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
    EVMasterViewController *_masterViewController;
    
    EVMainMenuViewController *_mainMenuViewController;
    EVWalletViewController *_walletViewController;
    
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

- (EVMasterViewController *)masterViewController {
    if (!_masterViewController) {
        _masterViewController = [[EVMasterViewController alloc] init];
        _masterViewController.rightFixedWidth = [UIScreen mainScreen].applicationFrame.size.width - EV_RIGHT_OVERHANG_MARGIN;
    }
    return _masterViewController;
}

- (EVMainMenuViewController *)mainMenuViewController {
    if (!_mainMenuViewController)
        _mainMenuViewController = [[EVMainMenuViewController alloc] init];
    return _mainMenuViewController;
}

- (EVWalletViewController *)walletViewController {
    if (!_walletViewController)
        _walletViewController = [[EVWalletViewController alloc] init];
    return _walletViewController;
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
