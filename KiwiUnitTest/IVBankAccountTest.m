//
//  EVBankAccount.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVBankAccount.h"

SPEC_BEGIN(EVBankAccountTest)

describe(@"save", ^{
   
    it(@"saves the Bank Account to the server", ^{
       
        __block NSString *uri = nil;
        
        [KWSpec loginWithEmail:@"seller@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer){
           
            EVBankAccount *bankAccount = [[EVBankAccount alloc] init];
            bankAccount.routingNumber = @"053101273";
            bankAccount.accountNumber = @"111111111111";
            bankAccount.type = @"savings";
            bankAccount.name = @"Johann Bernoulli";
            
            [bankAccount tokenizeWithSuccess:^{
                
                [bankAccount saveWithSuccess:^{
                    
                    uri = bankAccount.uri;
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
    
    it(@"gets all the Bank Account", ^{
        
        __block NSArray *bankAccounts = nil;
        
        [KWSpec loginWithEmail:@"seller@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer) {
            
            [EVBankAccount allWithSuccess:^(id result) {
                
                bankAccounts = result;
                killer();
                
            } failure:^(NSError *error) {
                killer();
            }];
            
        }];
        
        [[expectFutureValue(bankAccounts) shouldEventuallyBeforeTimingOutAfter(5.0)] haveCountOf:1];
        
    });
    
});

SPEC_END
