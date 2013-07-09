//
//  EVImages.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImages.h"

@implementation EVImages

#pragma mark - Backgrounds

+ (UIImage *)resizableTombstoneBackground {
    return [[UIImage imageNamed:@"FeedContainer"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

#pragma mark - Buttons

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

+ (UIImage *)inviteButtonBackground {
    return [[UIImage imageNamed:@"btn_invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 3, 16, 3)];
}

+ (UIImage *)inviteButtonBackgroundSelected {
    return [[UIImage imageNamed:@"btn_invited"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 3, 16, 3)];
}

+ (UIImage *)barButtonItemBackground {
    return [[UIImage imageNamed:@"Btn_Header_Normal"] stretchableImageWithLeftCapWidth:3 topCapHeight:13];
}

+ (UIImage *)barButtonItemBackgroundPress {
    return [[UIImage imageNamed:@"Btn_Header_Active"] stretchableImageWithLeftCapWidth:3 topCapHeight:13];
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

+ (UIImage *)filledDot {
    return [UIImage imageNamed:@"Request-header-dot"];
}

+ (UIImage *)emptyDot {
    return [UIImage imageNamed:@"Request-header-hole"];
}

#pragma mark - Onboarding

+ (UIImage *)addPhotoIcon {
    return [UIImage imageNamed:@"add-photo"];
}

+ (UIImage *)onboardCard1 {
    return [UIImage imageNamed:@"onboard-card1"];
}

+ (UIImage *)onboardCard2 {
    return [UIImage imageNamed:@"onboard-card2"];
}

+ (UIImage *)onboardCard3 {
    return [UIImage imageNamed:@"onboard-card3"];
}

+ (UIImage *)iTunesArtwork {
    return [UIImage imageNamed:@"iTunesArtwork"];
}

+ (UIImage *)facebookButton {
    return [[UIImage imageNamed:@"btn-facebook"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)facebookButtonPress {
    return [[UIImage imageNamed:@"btn-facebook"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)facebookFIcon {
    return [UIImage imageNamed:@"facebook-f"];
}

+ (UIImage *)checkHoleEmpty {
    return [UIImage imageNamed:@"check-hole"];
}

+ (UIImage *)checkHoleChecked {
    return [UIImage imageNamed:@"checked"];
}

+ (UIImage *)grayLogo {
    return [UIImage imageNamed:@"logo-gray"];
}

#pragma mark - Avatars

+ (UIImage *)defaultAvatar {
    int picNum = (arc4random() % 6) + 1;
    return [UIImage imageNamed:[NSString stringWithFormat:@"evenly_profilePic%i", picNum]];
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

#pragma mark - Loading

+ (UIImage *)loadingLogo {
    return [UIImage imageNamed:@"evenly_logo"];
}

+ (UIImage *)loadingSpinner {
    return [UIImage imageNamed:@"spinner"];
}

@end
