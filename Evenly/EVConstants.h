//
//  EVConstants.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Vine */

typedef enum {
    EVServerSelectionProduction,
    EVServerSelectionStaging,
    EVServerSelectionLocal
} EVServerSelection;

#define EV_API_PRODUCTION_URL @"https://www.paywithivy.com/api/v1/"
#define EV_API_STAGING_URL @"https://germ.herokuapp.com/api/v1/"
#define EV_API_LOCAL_URL @"http://localhost:3000/api/v1/"

#ifdef DEBUG
    #define EV_API_URL EV_API_STAGING_URL

    // To enable PonyDebugger, change this define from 0 to 1, uncomment the relevant lines in the
    // main Podfile, and run `pod install`.
    // DO NOT SUBMIT TO APPLE WITH PONYDEBUGGER BUILT INTO BINARY.
    #define EV_ENABLE_PONY_DEBUGGER 0
#else
    #define EV_API_URL EV_API_PRODUCTION_URL
#endif


/* Balanced */
#define BALANCED_PRODUCTION_URI @"/v1/marketplaces/MP4KYFmSZjnYzse0tPnu1s7l"
#define BALANCED_STAGING_URI @"/v1/marketplaces/TEST-MP2Hr48FkuOXqouGYxNBibAc"

#ifdef DEBUG
    #define BALANCED_URI BALANCED_STAGING_URI
#else
    #define BALANCED_URI BALANCED_PRODUCTION_URI
#endif

#pragma mark - Master View Controller

#define EV_RIGHT_OVERHANG_MARGIN 45.0

#pragma mark - Animation

#define EV_DEFAULT_ANIMATION_DURATION 0.25f
#define EV_DEFAULT_KEYBOARD_HEIGHT 216

#pragma mark - Exchange Fields

typedef enum {
    EVExchangeDetailFieldFrom = 0,
    EVExchangeDetailFieldTo,
    EVExchangeDetailFieldAmount,
    EVExchangeDetailFieldNote,
    EVExchangeDetailFieldDate,
    EVExchangeDetailFieldCOUNT
} EVExchangeDetailField;

#pragma mark - Signup Phases

typedef enum {
    EVSignUpPhaseAccountInfo,
    EVSignUpPhaseConfirmEmail,
    EVSignUpPhasePIN,
    EVSignUpPhasePicture,
    EVSignUpPhaseCOUNT
} EVSignUpPhase;

typedef enum {
    EVPrivacySettingNetwork,
    EVPrivacySettingFriends,
    EVPrivacySettingPrivate
} EVPrivacySetting;

#define EV_MINIMUM_DEPOSIT_AMOUNT 0.50
#define EV_MINIMUM_EXCHANGE_AMOUNT 0.50

#pragma mark - Block Typedefs

typedef void(^EVHandleTextChangeBlock)(NSString *text);

#pragma mark - History

#define EV_HISTORY_ITEMS_PER_PAGE 25