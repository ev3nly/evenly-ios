//
//  EVUtilities.h
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVConstants.h"
#import "EVColor.h"
#import "EVFont.h"
#import "EVImages.h"
#import "EVStringUtility.h"
#import "EVImageUtility.h"
#import "EVAnalyticsUtility.h"
#import "EVParseUtility.h"
#import "EVAppDelegate.h"
#import "EVStatusBarManager.h"
#import "EVNavigationController.h"
#import "EVLabel.h"

#import "EVCIA.h"

#import "NSArray+EVAdditions.h"
#import "NSDictionary+EVAdditions.h"
#import "NSString+EVAdditions.h"
#import "NSTimer+Blocks.h"
#import "NSDate+EVAdditions.h"
#import "UIView+EVAdditions.h"
#import "UITableView+EVAdditions.h"
#import "UIViewController+EVAdditions.h"
#import "UIColor+EVAdditions.h"
#import "UILabel+EVAdditions.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "ABContactsHelper+EVAdditions.h"
#import "ABContact+EVAdditions.h"

#import "MBProgressHUD.h"

@class EVFundingSource;

@interface EVUtilities : NSObject

+ (void)showAlertForError:(NSError *)error;
+ (void)registerForPushNotifications;
+ (void)buzz;

+ (EVAppDelegate *)appDelegate;

+ (EVFundingSource *)activeFundingSourceFromArray:(NSArray *)array;

+ (NSString *)dbidFromDictionary:(NSDictionary *)dictionary;

+ (BOOL)deviceHasTallScreen;
+ (BOOL)userHasIOS7;
+ (float)scaledDividerHeight;

+ (NSURL *)tosURL;
+ (NSURL *)privacyPolicyURL;

@end