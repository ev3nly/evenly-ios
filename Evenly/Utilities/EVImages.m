//
//  EVImages.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImages.h"

@implementation EVImages

+ (UIImage *)resizableTombstoneBackground {
    return [[UIImage imageNamed:@"FeedContainer"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

+ (UIImage *)blueButtonBackground {
    return [[UIImage imageNamed:@"btn_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)blueButtonBackgroundPress {
    return [[UIImage imageNamed:@"btn_blue-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)grayButtonBackground {
    return [[UIImage imageNamed:@"btn_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)grayButtonBackgroundPress {
    return [[UIImage imageNamed:@"btn_gray-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

#pragma mark - Privacy

+ (UIImage *)friendsIcon {
    return [UIImage imageNamed:@"Privacy-Friends"];
}

+ (UIImage *)globeIcon {
    return [UIImage imageNamed:@"Privacy-Globe"];
}

+ (UIImage *)lockIcon {
    return [UIImage imageNamed:@"Privacy-Lock"];
}

+ (UIImage *)dropdownArrow {
    return [UIImage imageNamed:@"Privacy-Dropdown"];
}

+ (UIImage *)checkIcon {
    return [UIImage imageNamed:@"Privacy-Check"];
}

#pragma mark - Income Icons

+ (UIImage *)incomeIcon {
    return [UIImage imageNamed:@"Income"];
}

+ (UIImage *)pendingIncomeIcon {
    return [UIImage imageNamed:@"PendingIncome"];
}

+ (UIImage *)paymentIcon {
    return [UIImage imageNamed:@"Payment"];
}

+ (UIImage *)pendingPaymentIcon {
    return [UIImage imageNamed:@"PendingPayment"];
}

+ (UIImage *)transferIcon {
    return [UIImage imageNamed:@"Transfer"];
}

#pragma mark - Menu Icons

+ (UIImage *)homeIcon {
    return [UIImage imageNamed:@"Home"];
}

+ (UIImage *)profileIcon {
    return [UIImage imageNamed:@"User"];
}

+ (UIImage *)settingsIcon {
    return [UIImage imageNamed:@"Settings"];
}

+ (UIImage *)supportIcon {
    return [UIImage imageNamed:@"Support"];
}

+ (UIImage *)inviteIcon {
    return [UIImage imageNamed:@"Invite"];
}

#pragma mark - Request

+ (UIImage *)inviteFriendsBanner {
    return [UIImage imageNamed:@"Request-Invite-Friends-Banner"];
}

#pragma mark - SignUp
+ (UIImage *)addPhotoIcon {
    return [UIImage imageNamed:@"add-photo"];
}

+ (UIImage *)defaultAvatar {
    return [UIImage imageNamed:@"DefaultAvatar"];
}

#pragma mark - Status Bar

+ (UIImage *)statusErrorBackground {
    return [UIImage imageNamed:@"status-error"];
}

+ (UIImage *)statusSuccessBackground {
    return [[UIImage imageNamed:@"status-success"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 0, 0, 4)];
}

+ (UIImage *)statusProgressBackground {
    return [UIImage imageNamed:@"status-progress"];
}

+ (UIImage *)statusProgressSpinner {
    return [UIImage imageNamed:@"status-progress-spinner"];
}

@end
