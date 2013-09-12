//
//  EVPushManager.m
//  Evenly
//
//  Created by Joseph Hankin on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPushManager.h"
#import "EVSerializer.h"

#import "EVRequest.h"
#import "EVPayment.h"
#import "EVGroupRequest.h"
#import "EVStory.h"
#import "EVUser.h"

#import "EVPendingDetailViewController.h"
#import "EVHistoryPaymentViewController.h"
#import "EVPendingGroupViewController.h"
#import "EVHistoryDepositViewController.h"
#import "EVStoryDetailViewController.h"
#import "EVProfileViewController.h"

NSString *const EVApplicationDidRegisterForPushesNotification = @"EVApplicationDidRegisterForPushesNotification";
NSString *const EVShouldRegisterForPushAtStartup = @"EVShouldRegisterForPushAtStartup";

@implementation EVPushManager

static EVPushManager *_sharedManager;

+ (EVPushManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [EVPushManager new];
    });
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSignOut:)
                                                     name:EVShouldRegisterForPushAtStartup
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)acceptsPushNotifications {
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return (BOOL)(type & UIRemoteNotificationTypeAlert);
}

- (EVObject *)objectFromPushDictionary:(NSDictionary *)pushDictionary {
    
    NSString *type = pushDictionary[@"type"];
    id dbid = pushDictionary[@"id"];
    if ([dbid isKindOfClass:[NSNumber class]]) {
        dbid = [dbid stringValue];
    }
    EVObject *object = [EVSerializer serializeType:type
                                              dbid:dbid];
    DLog(@"Object: %@  Loading? %@", object, (object.loading ? @"YES" : @"NO"));
    return object;
}

- (void)handleSignOut:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:EVShouldRegisterForPushAtStartup];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (EVViewController<EVReloadable> *)viewControllerFromPushDictionary:(NSDictionary *)pushDictionary {
    self.pushObject = [self objectFromPushDictionary:pushDictionary];
    self.pushObject.loading = YES;
    NSString *className = NSStringFromClass([self.pushObject class]);
    EVViewController<EVReloadable> *viewController = nil;
    if ([className isEqualToString:@"EVRequest"]) {
        viewController = [self pendingViewControllerWithRequest:(EVRequest *)self.pushObject];
    } else if ([className isEqualToString:@"EVPayment"]) {
        viewController = [self paymentViewControllerWithPayment:(EVPayment *)self.pushObject];
    } else if ([className isEqualToString:@"EVGroupRequest"]) {
        viewController = [self pendingGroupViewControllerWithGroupRequest:(EVGroupRequest *)self.pushObject];
    } else if ([className isEqualToString:@"EVWithdrawal"]) {
        viewController = [self depositViewControllerWithDeposit:(EVWithdrawal *)self.pushObject];
    } else if ([className isEqualToString:@"EVStory"]) {
        viewController = [self storyViewControllerWithStory:(EVStory *)self.pushObject];
    } else if ([className isEqualToString:@"EVUser"]) {
        viewController = [self profileViewControllerWithUser:(EVUser *)self.pushObject];
    }
    return viewController;
}

- (EVPendingDetailViewController *)pendingViewControllerWithRequest:(EVRequest *)request {
    EVPendingDetailViewController *controller = [[EVPendingDetailViewController alloc] initWithExchange:request];
    [RACAble(self.pushObject.loading) subscribeNext:^(NSNumber *loadingNumber) {
        if ([loadingNumber boolValue] == NO) {
            [controller reload];
        }
    }];
    return controller;
}

- (EVHistoryPaymentViewController *)paymentViewControllerWithPayment:(EVPayment *)payment {
    EVHistoryPaymentViewController *controller = [[EVHistoryPaymentViewController alloc] initWithPayment:payment];
    controller.canDismissManually = YES;
    [RACAble(self.pushObject.loading) subscribeNext:^(NSNumber *loadingNumber) {
        if ([loadingNumber boolValue] == NO) {
            [controller reload];
        }
    }];
    return controller;
}

- (EVPendingGroupViewController *)pendingGroupViewControllerWithGroupRequest:(EVGroupRequest *)groupRequest {
    EVPendingGroupViewController *controller = [[EVPendingGroupViewController alloc] initWithGroupRequest:groupRequest];
    [RACAble(self.pushObject.loading) subscribeNext:^(NSNumber *loadingNumber) {
        if ([loadingNumber boolValue] == NO) {
            [controller reload];
        }
    }];
    return controller;
}

- (EVHistoryDepositViewController *)depositViewControllerWithDeposit:(EVWithdrawal *)withdrawal {
    EVHistoryDepositViewController *controller = [[EVHistoryDepositViewController alloc] initWithWithdrawal:withdrawal];
    controller.canDismissManually = YES;
    [RACAble(self.pushObject.loading) subscribeNext:^(NSNumber *loadingNumber) {
        if ([loadingNumber boolValue] == NO) {
            [controller reload];
        }
    }];
    return controller;
}

- (EVStoryDetailViewController *)storyViewControllerWithStory:(EVStory *)story {
    EVStoryDetailViewController *controller = [[EVStoryDetailViewController alloc] initWithStory:story];
    controller.canDismissManually = YES;
    [RACAble(self.pushObject.loading) subscribeNext:^(NSNumber *loadingNumber) {
        if ([loadingNumber boolValue] == NO) {
            [controller reload];
        }
    }];
    return controller;
}

- (EVProfileViewController *)profileViewControllerWithUser:(EVUser *)user {
    EVProfileViewController *controller = [[EVProfileViewController alloc] initWithUser:user];
    controller.canDismissManually = YES;
    [RACAble(self.pushObject.loading) subscribeNext:^(NSNumber *loadingNumber) {
        if ([loadingNumber boolValue] == NO) {
            [controller reload];
        }
    }];
    return controller;
}

@end
