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
#import "EVStringUtility.h"
#import "EVImageUtility.h"
#import "EVAnalyticsUtility.h"
#import "EVAppDelegate.h"

#import "EVCIA.h"

#import "NSArray+EVAdditions.h"
#import "NSDictionary+EVAdditions.h"
#import "NSString+EVAdditions.h"
#import "NSTimer+Blocks.h"
#import "UIView+EVAdditions.h"
#import "UITableView+EVAdditions.h"
#import "UIViewController+EVAdditions.h"

#import "MBProgressHUD.h"

@class EVFundingSource;

@interface EVUtilities : NSObject

+ (void)showAlertForError:(NSError *)error;
+ (void)registerForPushNotifications;

+ (EVAppDelegate *)appDelegate;

+ (EVFundingSource *)activeFundingSourceFromArray:(NSArray *)array;

@end