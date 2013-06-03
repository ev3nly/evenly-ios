//
//  EVPaymentTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVPayment.h"
#import "EVError.h"
#import "EVUser.h"

SPEC_BEGIN(EVPaymentTest)

describe(@"save", ^{
   
    it(@"saves the Payment to the server", ^{
        
        __block NSString *dbid = nil;
        
        [KWSpec loginWithEmail:@"buyer@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer){
            
            EVPayment *payment = [[EVPayment alloc] initWithDictionary: @{
                                  @"amount":      @"20.00",
                                  @"description": @"Dinner @ Z & Y" }];
            EVContact *contact = [[EVContact alloc] init];
            contact.information = @"justin@paywithivy.com";
            payment.to = contact;
            
            [payment saveWithSuccess:^(void){
                
                dbid = payment.dbid;
                killer();
                
            } failure:^(NSError *error){
                
                killer();
                
            }];
            
        }];
        
        [[expectFutureValue(dbid) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        
    });
    
    context(@"no buyer role on User", ^{
       
        it(@"raises a Permissions error", ^{
           
            __block EVError *theError = nil;
            
            [KWSpec loginWithEmail:@"norole@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer){
               
                EVPayment *payment = [[EVPayment alloc] initWithDictionary: @{
                                      @"amount":      @"20.00",
                                      @"description": @"Dinner @ Z & Y" }];
                EVContact *contact = [[EVContact alloc] init];
                contact.information = @"justin@paywithivy.com";
                payment.to = contact;
                
                [payment saveWithSuccess:^(void){
                    
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
