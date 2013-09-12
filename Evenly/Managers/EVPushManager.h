//
//  EVPushManager.h
//  Evenly
//
//  Created by Joseph Hankin on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVViewController.h"

extern NSString *const EVApplicationDidRegisterForPushesNotification;

extern NSString *const EVShouldRegisterForPushAtStartup;

@interface EVPushManager : NSObject

@property (nonatomic, strong) EVObject *pushObject;

+ (EVPushManager *)sharedManager;
+ (BOOL)acceptsPushNotifications;

- (EVObject *)objectFromPushDictionary:(NSDictionary *)pushDictionary;
- (EVViewController<EVReloadable> *)viewControllerFromPushDictionary:(NSDictionary *)pushDictionary;

- (void)handleSignOut:(NSNotification *)notification;

@end
