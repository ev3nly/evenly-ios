//
//  EVAnalyticsUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 4/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAnalyticsUtility.h"
#import <Mixpanel/Mixpanel.h>

NSString *const EVAnalyticsOpenedApp = @"Opened app";
NSString *const EVAnalyticsAddedCard = @"Added card";
NSString *const EVAnalyticsSignedOut = @"Signed out";

NSString *const EVAnalyticsPressedInviteFromContacts = @"Was prompted for confirmation from Invite Contacts";
NSString *const EVAnalyticsConfirmedInviteFromContacts = @"Confirmed Invite Contacts";
NSString *const EVAnalyticsCanceledInviteFromContacts = @"Canceled Invite Contacts";

@implementation EVAnalyticsUtility

+ (void)trackEvent:(NSString *)event {
    [self trackEvent:event properties:nil];
}

+ (void)trackEvent:(NSString *)event properties:(NSDictionary *)properties {
    [[Mixpanel sharedInstance] track:event properties:properties];
}

@end
