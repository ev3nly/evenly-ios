//
//  EVValidator.h
//  Evenly
//
//  Created by Justin Brunet on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EVFormValidationTypeEmail,
    EVFormValidationTypePhoneNumber,
    EVFormValidationTypeCurrency
} EVFormValidationType;

@interface EVValidator : NSObject

+ (id)sharedValidator;

- (void)validateTextField:(UITextField *)textField forType:(EVFormValidationType)formType;

- (BOOL)stringIsValidEmail:(NSString *)string;

@end
