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

#import "EVPendingDetailViewController.h"
#import "EVHistoryPaymentViewController.h"
#import "EVPendingGroupViewController.h"

@implementation EVPushManager

static EVPushManager *_sharedManager;

+ (EVPushManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [EVPushManager new];
    });
    return _sharedManager;
}

- (EVObject *)objectFromPushDictionary:(NSDictionary *)pushDictionary {
    EVObject *object = [EVSerializer serializeType:pushDictionary[@"type"]
                                              dbid:pushDictionary[@"id"]];
    DLog(@"Object: %@  Loading? %@", object, (object.loading ? @"YES" : @"NO"));
    return object;
}

- (EVViewController<EVReloadable> *)viewControllerFromPushDictionary:(NSDictionary *)pushDictionary {
    self.pushObject = [self objectFromPushDictionary:pushDictionary];
    NSString *className = NSStringFromClass([self.pushObject class]);
    EVViewController<EVReloadable> *viewController = nil;
    if ([className isEqualToString:@"EVRequest"]) {
        viewController = [self pendingViewControllerWithRequest:(EVRequest *)self.pushObject];
    } else if ([className isEqualToString:@"EVPayment"]) {
        viewController = [self paymentViewControllerWithPayment:(EVPayment *)self.pushObject];
    } else if ([className isEqualToString:@"EVGroupRequest"]) {
        viewController = [self pendingGroupViewControllerWithGroupRequest:(EVGroupRequest *)self.pushObject];
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

@end
