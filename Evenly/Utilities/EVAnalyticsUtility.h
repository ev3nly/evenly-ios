//
//  EVAnalyticsUtility.h
//  Evenly
//
//  Created by Joseph Hankin on 4/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const EVAnalyticsOpenedApp;
extern NSString *const EVAnalyticsAddedCard;
extern NSString *const EVAnalyticsSignedOut;

extern NSString *const EVAnalyticsPressedInviteFromContacts;
extern NSString *const EVAnalyticsConfirmedInviteFromContacts;
extern NSString *const EVAnalyticsCanceledInviteFromContacts;

@interface EVAnalyticsUtility : NSObject

+ (void)trackEvent:(NSString *)event;
+ (void)trackEvent:(NSString *)event properties:(NSDictionary *)properties;

@end
