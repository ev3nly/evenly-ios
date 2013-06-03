//
//  EVWithdrawalTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVWithdrawal.h"
#import "EVError.h"

SPEC_BEGIN(EVWithdrawalTest)

describe(@"save", ^{
   
    it(@"saves the Withdrawal to the server", ^{
       
        __block NSString *dbid = nil;
        
        [KWSpec loginWithEmail:@"seller@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer){
           
            EVWithdrawal *withdrawal = [[EVWithdrawal alloc] initWithDictionary:@{@"amount": @"0.50"}];
            
            [withdrawal saveWithSuccess:^{
                
                dbid = withdrawal.dbid;
                killer();
                
            } failure:^(NSError *error){
                killer();
            }];
            
        }];
        
        [[expectFutureValue(dbid) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        
    });
    
    context(@"no seller role on User", ^{
       
        it(@"raises a Permissions error", ^{
           
            __block EVError *theError = nil;
            
            [KWSpec loginWithEmail:@"seansu4you87@gmail.com" password:@"haisean" andSuccess:^(KillWait killer){
                
                EVWithdrawal *withdrawal = [[EVWithdrawal alloc] initWithDictionary:@{@"amount": @"0.50"}];
                
                [withdrawal saveWithSuccess:^{
                    
                    killer();
                    
                } failure:^(NSError *error){
                    
                    theError = (EVError *)error;
                    killer();
                    
                }];
                
            }];
            
            [[expectFutureValue([NSNumber numberWithInt:theError.code]) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(403)];
            
        });
        
    });
    
});

SPEC_END
