//
//  EVSettingsManager.h
//  Evenly
//
//  Created by Joseph Hankin on 5/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EVNotificationSetting;

extern NSString *const EVHasSeenGroupRequestDashboardAlertKey;
extern NSString *const EVHasSeenPINAlertKey;
extern NSString *const EVDateAppEnteredBackgroundKey;

extern NSString *const EVSettingsWereLoadedFromServerNotification;

@interface EVSettingsManager : NSObject

@property (nonatomic, strong) EVNotificationSetting *notificationSetting;

+ (instancetype)sharedManager;

- (void)loadSettingsFromServer;
- (void)checkForPushPermissionAndUpdateSettingAccordingly;

@end
