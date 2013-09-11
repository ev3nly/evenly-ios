//
//  EVUtilities.m
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSource.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation EVUtilities

+ (void)showAlertForError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:error.localizedDescription
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)registerForPushNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
}

+ (void)buzz {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (EVAppDelegate *)appDelegate {
    return (EVAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (EVFundingSource *)activeFundingSourceFromArray:(NSArray *)array {
    __block EVFundingSource *activeCard = nil;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(EVFundingSource *)obj isActive]) {
            activeCard = (EVFundingSource *)obj;
            *stop = YES;
        }
    }];
    return activeCard;
}

+ (NSString *)dbidFromDictionary:(NSDictionary *)dictionary {
    NSString *dbid;
    if ([[dictionary valueForKey:@"id"] respondsToSelector:@selector(stringValue)])
        dbid = [[dictionary valueForKey:@"id"] stringValue];
    else
        dbid = [dictionary valueForKey:@"id"];
    return dbid;
}

+ (BOOL)deviceHasTallScreen {
    return ([UIApplication sharedApplication].keyWindow.bounds.size.height > 480.0);
}

+ (BOOL)userHasIOS7 {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    window = window ?: [UIView new];
    return [window respondsToSelector:@selector(tintColor)];
}

+ (float)scaledDividerHeight {
    return (1.0 / [UIScreen mainScreen].scale);
}

+ (NSURL *)tosURL {
    return [NSURL fileURLWithPath:EV_BUNDLE_PATH(@"Terms and Conditions.html")];
}

+ (NSURL *)privacyPolicyURL {
    return [NSURL fileURLWithPath:EV_BUNDLE_PATH(@"Privacy Policy.html")];
}

@end