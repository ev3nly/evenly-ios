//
//  EVChargeTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVCharge.h"
#import "EVUser.h"

SPEC_BEGIN(EVChargeTest)

describe(@"save", ^{
    
    it(@"saves the Charge to the server", ^{
        
        __block NSString *dbid = nil;
        
        [KWSpec loginWithEmail:@"seansu4you87@gmail.com" password:@"haisean" andSuccess:^(KillWait killer){
            EVCharge *charge = [[EVCharge alloc] initWithDictionary: @{
                                @"amount":      @"10.00",
                                @"description": @"Lunch @ Sai's" }];
            EVContact *contact = [[EVContact alloc] init];
            contact.information = @"joe@paywithivy.com";
            charge.to = contact;
            
            [charge saveWithSuccess:^(void){
                
                dbid = charge.dbid;
                killer();
                
            } failure:^(NSError *error){
                
                killer();
                
            }];
            
        }];
        
        [[expectFutureValue(dbid) shouldEventually] beNonNil];
        
    });
    
});

SPEC_END