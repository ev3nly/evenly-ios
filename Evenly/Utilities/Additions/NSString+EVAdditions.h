//
//  NSString+EVAdditions.h
//  Evenly
//
//  Created by Sean Yu on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EVAdditions)

+ (BOOL)isBlank:(NSString *)string;

- (BOOL)isInteger;
- (BOOL)isEmail;
- (BOOL)isPhoneNumber;

- (BOOL)containsString:(NSString *)string;

@end
