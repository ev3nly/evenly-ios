//
//  ABContact+EVAdditions.m
//  Evenly
//
//  Created by Joseph Hankin on 8/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "ABContact+EVAdditions.h"

@implementation ABContact (EVAdditions)

- (NSString *)mobileNumber {
    for (NSDictionary *dictionary in [self phoneDictionaries]) {
        if ([dictionary[@"label"] isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            return dictionary[@"value"];
    }
    return nil;
}

- (NSString *)iPhoneNumber {
    for (NSDictionary *dictionary in [self phoneDictionaries]) {
        if ([dictionary[@"label"] isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel])
            return dictionary[@"value"];
    }
    return nil;
}

@end
