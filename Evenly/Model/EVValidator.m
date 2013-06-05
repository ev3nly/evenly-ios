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
    return NO;
}

@end
