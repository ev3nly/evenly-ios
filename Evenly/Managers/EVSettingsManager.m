//
//  EVSettingsManager.m
//  Evenly
//
//  Created by Joseph Hankin on 5/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSettingsManager.h"
#import "EVNotificationSetting.h"
#import "EVPushManager.h"

NSString *const EVHasSeenGroupRequestDashboardAlertKey = @"EVHasSeenGroupRequestDashboardAlertKey";
NSString *const EVHasSeenPINAlertKey = @"EVHasSeenPINAlertKey";
NSString *const EVDateAppEnteredBackgroundKey = @"EVAppEnteredBackgroundDate";

NSString *const EVSettingsWereLoadedFromServerNotification = @"EVSettingsWereLoadedFromServerNotification";

static EVSettingsManager *_sharedManager;

@implementation EVSettingsManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EVSettingsManager alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)loadSettingsFromServer {
    [EVNotificationSetting allWithSuccess:^(id result) {
        self.notificationSetting = [result lastObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVSettingsWereLoadedFromServerNotification object:nil];
    } failure:^(NSError *error) {
        DLog(@"Error loading setting: %@", error);
    }];
}

- (EVNotificationSetting *)notificationSetting {
    if (_notificationSetting == nil)
        [self loadSettingsFromServer];
    return _notificationSetting;
}

// Note that this should be done only once, after new user sign-up.
- (void)checkForPushPermissionAndUpdateSettingAccordingly {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self checkForPushPermissionAndUpdateSettingAccordingly];
    });
    
    if (![EVPushManager acceptsPushNotifications])
    {
        EVNotificationSetting *setting = [self notificationSetting];
        [setting setPush:NO];
        [setting updateWithSuccess:^{
            DLog(@"Success");
        } failure:^(NSError *error) {
            DLog(@"Failure: %@", error);
        }];
    }
}

@end
