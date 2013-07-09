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

@interface EVSettingsManager : NSObject

@property (nonatomic, strong) EVNotificationSetting *notificationSetting;

+ (instancetype)sharedManager;

- (void)loadSettingsFromServer;

@end
