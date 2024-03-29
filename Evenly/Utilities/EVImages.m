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

#pragma - Sign In/Pin Logos

+ (UIImage *)securityLogoGray {
    return [UIImage imageNamed:@"security_logo_gray"];
}

+ (UIImage *)securityLogoColor {
    return [UIImage imageNamed:@"security_logo_color"];
}

#pragma mark - NavBar

+ (UIImage *)navBarBackground {
    return [EVImageUtility overlayImage:[UIImage imageNamed:@"Header"] withColor:[EVColor blueColor] identifier:@"navBarImage"];
}

+ (UIImage *)navBarBackButton {
    return [UIImage imageNamed:@"Back_noshadow"];
}

+ (UIImage *)navBarCancelButton {
    return [UIImage imageNamed:@"close_noshadow"];
}

+ (UIImage *)navBarNotificationBackground {
    CGSize imageSize = [UIImage imageNamed:@"pending-number-container"].size;
    return [[UIImage imageNamed:@"pending-number-container"] resizableImageWithCapInsets:UIEdgeInsetsMake(imageSize.height/2,
                                                                                                          imageSize.width/2,
                                                                                                          imageSize.height/2,
                                                                                                          imageSize.width/2)];
}

+ (UIImage *)navBarNotificationBackgroundRed {
    CGSize imageSize = [UIImage imageNamed:@"pending-number-container-red"].size;
    return [[EVImageUtility overlayImage:[UIImage imageNamed:@"pending-number-container-red"]
                               withColor:[EVColor lightRedColor]
                              identifier:@"redNotificationBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(imageSize.height/2,
                                                                                                                    imageSize.width/2,
                                                                                                                    imageSize.height/2,
                                                                                                                    imageSize.width/2)];
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

#pragma mark - Sharing

+ (UIImage *)shareEvenlyActive {
    return [UIImage imageNamed:@"evenly_active"];
}

+ (UIImage *)shareEvenlyInactive {
    return [UIImage imageNamed:@"evenly_inactive"];
}

+ (UIImage *)shareFacebookActive {
    return [UIImage imageNamed:@"facebook_active"];
}

+ (UIImage *)shareFacebookInactive {
    return [UIImage imageNamed:@"facebook_inactive"];
}

+ (UIImage *)shareTwitterActive {
    return [UIImage imageNamed:@"twitter_active"];
}

+ (UIImage *)shareTwitterInactive {
    return [UIImage imageNamed:@"twitter_inactive"];
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

+ (UIImage *)dashboardTabInactiveBackground {
    return [UIImage imageNamed:@"tab-inactive-background"];
}

+ (UIImage *)dashboardDisclosureArrow {
    return [UIImage imageNamed:@"Arrow"];
}

+ (UIImage *)greenCheck {
    return [UIImage imageNamed:@"green_check"];
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

+ (UIImage *)onboardCard4 {
    return [UIImage imageNamed:@"onboard-card4"];
}

+ (UIImage *)bigIcon {
    return [UIImage imageNamed:@"ob_icon_no_lip"];
}

+ (UIImage *)facebookButton {
    return [[UIImage imageNamed:@"btn-facebook"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)facebookButtonPress {
    return [[UIImage imageNamed:@"btn-facebook-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
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
    return [UIImage imageNamed:@"security_logo_gray"];
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

+ (UIImage *)grayLoadingLogo {
    return [UIImage imageNamed:@"evenly_logo_gray"];
}

+ (UIImage *)loadingSpinner {
    return [UIImage imageNamed:@"spinner"];
}

#pragma mark - Invite

+ (UIImage *)inviteContactsIcon {
    return [UIImage imageNamed:@"contact"];
}

+ (UIImage *)inviteFacebookIcon {
    return [UIImage imageNamed:@"facebook"];
}

+ (UIImage *)invitePlusIcon {
    return [UIImage imageNamed:@"plus"];
}

#pragma mark - Banks and Cards

+ (UIImage *)banksCardsAddIcon {
    return [UIImage imageNamed:@"bc_add"];
}

+ (UIImage *)banksCardsDeleteIcon {
    return [UIImage imageNamed:@"bc_remove"];
}

+ (UIImage *)bankIllustration {
    return [UIImage imageNamed:@"bc_bank_illo"];
}

+ (UIImage *)cardIllustration {
    return [UIImage imageNamed:@"bc_card_illo"];
}

#pragma mark - Settings

+ (UIImage *)settingsNotificationsIcon {
    return [UIImage imageNamed:@"Settings_notification_globe"];
}

+ (UIImage *)settingsPasscodeIcon {
    return [UIImage imageNamed:@"Settings_passcode_key"];
}

+ (UIImage *)settingsFacebookIcon {
    return [UIImage imageNamed:@"facebook_small"];
}

+ (UIImage *)settingsLogoutIcon {
    return [UIImage imageNamed:@"Settings_logout_arrow"];
}

#pragma mark - Rewards

+ (UIImage *)rewardCardLogo {
    return [UIImage imageNamed:@"white_logo"];
}

+ (UIImage *)noRewardsSadFace {
    return [UIImage imageNamed:@"no_rewards_sadface"];
}


@end
