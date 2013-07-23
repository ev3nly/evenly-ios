//
//  EVNavigationManager.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationManager.h"
#import "EVNavBarBadge.h"

#define NAV_BAR_BADGE_TAG 9237
#define BADGE_VIEW_OFFSET 0.5

static EVNavigationManager *_sharedManager;

@interface EVNavigationManager () {
    EVMasterViewController *_masterViewController;
    
    EVMainMenuViewController *_mainMenuViewController;
    EVWalletViewController *_walletViewController;
    
    UINavigationController *_homeViewController;
    UINavigationController *_profileViewController;
    UINavigationController *_inviteViewController;
    UINavigationController *_settingsViewController;
    
    EVNavBarBadge *_badgeView;
}

@end

@implementation EVNavigationManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EVNavigationManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_sharedManager
                                                 selector:@selector(userSignedOut:)
                                                     name:EVSessionSignedOutNotification
                                                   object:nil];
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
        _profileViewController = [[UINavigationController alloc] initWithRootViewController:[[EVProfileViewController alloc] initWithUser:[EVCIA me]]];
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

- (void)userSignedOut:(NSNotification *)notification {
    _profileViewController = nil;
}

- (void)setPendingNotifications:(int)numPending shouldFlag:(BOOL)shouldFlag {
    if (!_badgeView)
        _badgeView = [EVNavBarBadge new];
    
    _badgeView.number = numPending;
    _badgeView.shouldFlag = shouldFlag;
    _badgeView.frame = [self badgeViewFrame];

    if (numPending > 0)
        [_homeViewController.navigationBar addSubview:_badgeView];
    else
        [_badgeView removeFromSuperview];
}

- (CGRect)badgeViewFrame {
    [_badgeView sizeToFit];
    UIViewController *homeController = [_homeViewController.viewControllers objectAtIndex:0];
    return CGRectMake(homeController.navigationItem.rightBarButtonItem.customView.frame.origin.x - _badgeView.bounds.size.width,
                      homeController.navigationItem.rightBarButtonItem.customView.frame.origin.y - BADGE_VIEW_OFFSET,
                      _badgeView.bounds.size.width,
                      _badgeView.bounds.size.height);
}

@end
