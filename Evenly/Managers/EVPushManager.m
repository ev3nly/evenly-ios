//
//  EVPushManager.m
//  Evenly
//
//  Created by Joseph Hankin on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPushManager.h"
#import "EVSerializer.h"
#import "EVPendingDetailViewController.h"
#import "EVRequest.h"

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
    if ([className isEqualToString:@"EVRequest"]) {
        return [self pendingViewControllerWithRequest:(EVRequest *)self.pushObject];
    }
    return nil;
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

@end
