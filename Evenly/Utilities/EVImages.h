//
//  EVImages.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVImages : NSObject

#pragma mark - Backgrounds
+ (UIImage *)resizableTombstoneBackground;

#pragma - Sign In/Pin Logos
+ (UIImage *)securityLogoGray;
+ (UIImage *)securityLogoColor;

#pragma mark - NavBar
+ (UIImage *)navBarBackground;
+ (UIImage *)navBarBackButton;
+ (UIImage *)navBarCancelButton;
+ (UIImage *)navBarNotificationBackground;
+ (UIImage *)navBarNotificationBackgroundRed;

#pragma mark - Button Backgrounds
+ (UIImage *)blueButtonBackground;
+ (UIImage *)blueButtonBackgroundPress;
+ (UIImage *)grayButtonBackground;
+ (UIImage *)grayButtonBackgroundPress;
+ (UIImage *)inviteButtonBackground;
+ (UIImage *)inviteButtonBackgroundSelected;
+ (UIImage *)barButtonItemBackground;
+ (UIImage *)barButtonItemBackgroundPress;

#pragma mark - Privacy
+ (UIImage *)friendsIcon;
+ (UIImage *)globeIcon;
+ (UIImage *)lockIcon;
+ (UIImage *)dropdownArrow;
+ (UIImage *)checkIcon;

#pragma mark - Income Icons
+ (UIImage *)incomeIcon;
+ (UIImage *)pendingIncomeIcon;
+ (UIImage *)paymentIcon;
+ (UIImage *)pendingPaymentIcon;
+ (UIImage *)transferIcon;

#pragma mark - Menu Icons
+ (UIImage *)homeIcon;
+ (UIImage *)profileIcon;
+ (UIImage *)settingsIcon;
+ (UIImage *)supportIcon;
+ (UIImage *)inviteIcon;

#pragma mark - Request
+ (UIImage *)inviteFriendsBanner;
+ (UIImage *)filledDot;
+ (UIImage *)emptyDot;
+ (UIImage *)dashboardTabInactiveBackground;
+ (UIImage *)dashboardDisclosureArrow;

#pragma mark - Onboarding
+ (UIImage *)addPhotoIcon;
+ (UIImage *)defaultAvatar;
+ (UIImage *)onboardCard1;
+ (UIImage *)onboardCard2;
+ (UIImage *)onboardCard3;
+ (UIImage *)bigIcon;
+ (UIImage *)facebookButton;
+ (UIImage *)facebookButtonPress;
+ (UIImage *)facebookFIcon;
+ (UIImage *)checkHoleEmpty;
+ (UIImage *)checkHoleChecked;
+ (UIImage *)grayLogo;

#pragma mark - Status Bar
+ (UIImage *)statusErrorBackground;
+ (UIImage *)statusSuccessBackground;
+ (UIImage *)statusProgressBackground;
+ (UIImage *)statusProgressSpinner;

#pragma mark - Loading
+ (UIImage *)loadingLogo;
+ (UIImage *)grayLoadingLogo;
+ (UIImage *)loadingSpinner;

#pragma mark - Invite
+ (UIImage *)inviteContactsIcon;
+ (UIImage *)inviteFacebookIcon;

#pragma mark - Banks and Cards
+ (UIImage *)banksCardsAddIcon;
+ (UIImage *)banksCardsDeleteIcon;
+ (UIImage *)bankIllustration;
+ (UIImage *)cardIllustration;

@end
