//
//  EVImages.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVImages : NSObject

+ (UIImage *)resizableTombstoneBackground;

#pragma mark - Button Backgrounds
+ (UIImage *)blueButtonBackground;
+ (UIImage *)blueButtonBackgroundPress;
+ (UIImage *)grayButtonBackground;
+ (UIImage *)grayButtonBackgroundPress;

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

#pragma mark - Onboarding
+ (UIImage *)addPhotoIcon;
+ (UIImage *)defaultAvatar;
+ (UIImage *)onboardCard1;
+ (UIImage *)onboardCard2;
+ (UIImage *)onboardCard3;
+ (UIImage *)iTunesArtwork;

#pragma mark - Status Bar
+ (UIImage *)statusErrorBackground;
+ (UIImage *)statusSuccessBackground;
+ (UIImage *)statusProgressBackground;
+ (UIImage *)statusProgressSpinner;

@end
