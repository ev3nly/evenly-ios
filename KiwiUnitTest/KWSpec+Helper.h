//
//  EVRequestTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "KWSpec.h"

typedef void (^ KillWait)();

@interface KWSpec (Helper)

+ (void)waitWithTimeout:(NSTimeInterval)timeout forCondition:(BOOL(^)())conditionalBlock;
+ (void)loginWithEmail:(NSString *)email password:(NSString *)password andSuccess:(void(^)(KillWait killer))success;

@end