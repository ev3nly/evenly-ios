//
//  EVNavigationManager.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationManager.h"
#import "EVNavBarBadge.h"
#import "ReactiveCocoa.h"

#define NAV_BAR_BADGE_TAG 9237
#define BADGE_VIEW_OFFSET 0.5

static EVNavigationManager *_sharedManager;

@interface EVNavigationManager () {
    EVMasterViewController *_masterViewController;
    
    EVMainMenuViewController *_mainMenuViewController;
    EVWalletViewController *_walletViewController;
    
    EVNavigationController *_homeViewController;
    EVNavigationController *_profileViewController;
    EVNavigationController *_inviteViewController;
    EVNavigationController *_settingsViewController;
}

@property (nonatomic, strong) EVNavBarBadge *badgeView;

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
        _masterViewController.leftFixedWidth = _masterViewController.rightFixedWidth;
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

- (EVNavigationController *)homeViewController {
    if (!_homeViewController)
        _homeViewController = [[EVNavigationController alloc] initWithRootViewController:[[EVHomeViewController alloc] init]];
    return _homeViewController;
}

- (EVNavigationController *)profileViewController {
    if (!_profileViewController)
        _profileViewController = [[EVNavigationController alloc] initWithRootViewController:[[EVProfileViewController alloc] initWithUser:[EVCIA me]]];
    return _profileViewController;
}

- (EVNavigationController *)inviteViewController {
    if (!_inviteViewController)
        _inviteViewController = [[EVNavigationController alloc] initWithRootViewController:[[EVInviteViewController alloc] init]];
    return _inviteViewController;
}

- (EVNavigationController *)settingsViewController {
    if (!_settingsViewController)
        _settingsViewController = [[EVNavigationController alloc] initWithRootViewController:[[EVSettingsViewController alloc] init]];
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
    if (!self.badgeView)
        self.badgeView = [EVNavBarBadge new];
    
    self.badgeView.number = numPending;
    self.badgeView.shouldFlag = shouldFlag;
    self.badgeView.frame = [self badgeViewFrame];

    if (numPending > 0 && !self.badgeView.superview) {
        UIView *button = [self walletButtonCustomView];
        [button addSubview:self.badgeView];
    }
    else if (numPending <= 0 && self.badgeView.superview) {
        [self.badgeView removeFromSuperview];
        self.badgeView = nil;
    }
}

- (UIView *)walletButtonCustomView {
    UIViewController *homeController = [_homeViewController.viewControllers objectAtIndex:0];
    return homeController.navigationItem.rightBarButtonItem.customView;
}

- (CGRect)badgeViewFrame {
    [self.badgeView sizeToFit];
    return CGRectMake(0 - self.badgeView.bounds.size.width,
                      BADGE_VIEW_OFFSET,
                      self.badgeView.bounds.size.width,
                      self.badgeView.bounds.size.height);
}

@end
