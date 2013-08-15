//
//  ABContact+EVAdditions.m
//  Evenly
//
//  Created by Joseph Hankin on 8/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "ABContact+EVAdditions.h"

@implementation ABContact (EVAdditions)

- (NSString *)evenlyContactString {
    if ([self iPhoneNumber])
        return [self iPhoneNumber];
    else if ([self mobileNumber])
        return [self mobileNumber];
    else if ([self mainNumber])
        return [self mainNumber];
    else if ([self workNumber])
        return [self workNumber];
    else if ([self homeNumber])
        return [self homeNumber];
    else if ([self otherNumber])
        return [self otherNumber];
    else
        return [[self emailArray] objectAtIndex:0];
}

- (BOOL)hasPhoneNumber {
    return !![self iPhoneNumber] || !![self mobileNumber];
}

- (NSString *)iPhoneNumber {
    return [self numberForAddressBookKey:(NSString *)kABPersonPhoneIPhoneLabel];
}

- (NSString *)mobileNumber {
    return [self numberForAddressBookKey:(NSString *)kABPersonPhoneMobileLabel];
}

- (NSString *)mainNumber {
    return [self numberForAddressBookKey:(NSString *)kABPersonPhoneMainLabel];
}

- (NSString *)workNumber {
    return [self numberForAddressBookKey:(NSString *)kABWorkLabel];
}

- (NSString *)homeNumber {
    return [self numberForAddressBookKey:(NSString *)kABHomeLabel];
}

- (NSString *)otherNumber {
    return [self numberForAddressBookKey:(NSString *)kABOtherLabel];
}

- (NSString *)numberForAddressBookKey:(NSString *)key {
    for (NSDictionary *dictionary in [self phoneDictionaries]) {
        if ([dictionary[@"label"] isEqualToString:key])
            return dictionary[@"value"];
    }
    return nil;
}



@end
