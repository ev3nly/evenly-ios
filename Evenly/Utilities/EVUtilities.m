//
//  EVUtilities.m
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSource.h"

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

@end