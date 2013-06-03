//
//  EVCreditCardTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVCreditCard.h"

SPEC_BEGIN(EVCreditCardTest)

describe(@"save", ^{
   
    it(@"saves the Credit Card to the server", ^{
       
        __block NSString *uri = nil;
        
        [KWSpec loginWithEmail:@"buyer@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer){
           
            EVCreditCard *card = [[EVCreditCard alloc] init];
            card.number = @"4111111111111111";
            card.expirationMonth = @"8";
            card.expirationYear = @"2025";
            card.cvv = @"123";
            
            [card tokenizeWithSuccess:^{
               
                [card saveWithSuccess:^{
                   
                    uri = card.uri;
                    killer();
                    
                } failure:^(NSError *error){
                    killer();
                }];
                
            } failure:^(NSError *error){
                killer();
            }];
            
        }];
        
        [[expectFutureValue(uri) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        
    });
    
});

describe(@"all", ^{
   
    it(@"gets all the Credit Cards", ^{
       
        __block NSArray *creditCards = nil;
        
        [KWSpec loginWithEmail:@"buyer@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer) {
            
           [EVCreditCard allWithSuccess:^(id result) {

               creditCards = result;
               killer();
               
           } failure:^(NSError *error) {
               killer();
           }];
            
        }];
        
        [[expectFutureValue(creditCards) shouldEventuallyBeforeTimingOutAfter(5.0)] haveCountOf:1];
        
    });
    
});

SPEC_END