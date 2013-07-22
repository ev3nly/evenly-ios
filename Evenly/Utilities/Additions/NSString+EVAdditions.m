//
//  NSString+EVAdditions.m
//  Evenly
//
//  Created by Sean Yu on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "NSString+EVAdditions.h"

@implementation NSString(EVAdditions)

+ (BOOL)isBlank:(NSString *)string {
    return [string length] == 0;
}

- (BOOL)isInteger {
    if ([self length] == 0) {
        return NO;
    }
    NSCharacterSet *numericCharSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *searchFieldSet = [NSCharacterSet characterSetWithCharactersInString:self];
    
    return [numericCharSet isSupersetOfSet:searchFieldSet];
}

- (BOOL)isEmail {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isPhoneNumber {
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [self length]);
    NSArray *matches = [detector matchesInString:self options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}

- (BOOL)containsString:(NSString *)string {
    return [self rangeOfString:string].location != NSNotFound;
}

@end
