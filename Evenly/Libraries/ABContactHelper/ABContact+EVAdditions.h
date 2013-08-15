//
//  ABContact+EVAdditions.h
//  Evenly
//
//  Created by Joseph Hankin on 8/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "ABContact.h"

@interface ABContact (EVAdditions)

- (NSString *)evenlyContactString;

- (BOOL)hasPhoneNumber;
- (NSString *)mobileNumber;
- (NSString *)iPhoneNumber;
- (NSString *)mainNumber;
- (NSString *)workNumber;
- (NSString *)homeNumber;
- (NSString *)otherNumber;

@end
