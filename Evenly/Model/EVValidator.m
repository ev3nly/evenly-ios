//
//  EVValidator.m
//  Evenly
//
//  Created by Justin Brunet on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVValidator.h"

@implementation EVValidator

static EVValidator *_sharedValidator = nil;

+ (id)sharedValidator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedValidator = [EVValidator new];
    });
    return _sharedValidator;
}

#pragma mark - Registration

- (void)validateTextField:(UITextField *)textField forType:(EVFormValidationType)formType
{
    
}

#pragma mark - Validation

- (BOOL)stringIsValid:(NSString *)string forType:(EVFormValidationType)type {
    return NO;
}

- (BOOL)stringIsValidEmail:(NSString *)string {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\w]+@[\\w]+\\.[\\w]{2,4}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    __block BOOL foundMatching = NO;
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, string.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             foundMatching = YES;
                             *stop = YES;
                         }];
    return foundMatching;
    if ([string rangeOfString:@"."].location == NSNotFound)
        return NO;
    if ([string rangeOfString:@"@"].location == NSNotFound)
        return NO;
    return YES;
}

@end
