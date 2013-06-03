//
//  EVChargeTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "KWSpec+Helper.h"
#import "EVSession.h"

@implementation KWSpec (Helper)

+ (void)waitWithTimeout:(NSTimeInterval)timeout forCondition:(BOOL(^)())conditionalBlock {
    NSDate *timeoutDate = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
    while (conditionalBlock() == NO) {
        if ([timeoutDate timeIntervalSinceDate:[NSDate date]] < 0) {
            return;
        }
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password andSuccess:(void(^)(KillWait killer))success
{
    __block BOOL requestCompleted = NO;
    
    KillWait killer = ^{
        requestCompleted = YES;
    };
    
    [EVSession createWithEmail:email password:password success:^(void){
        
        
        success(killer);
        
    } failure:^(NSError *error){
        
        requestCompleted = YES;
        
    }];
    
    [KWSpec waitWithTimeout:10.0 forCondition:^BOOL() {
        return requestCompleted;
    }];
}

@end