//
//  EVPushManager.m
//  Evenly
//
//  Created by Joseph Hankin on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPushManager.h"
#import "EVSerializer.h"

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


@end
