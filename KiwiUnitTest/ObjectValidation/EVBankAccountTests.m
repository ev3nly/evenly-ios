//
//  EVBankAccountTests.m
//  Evenly
//
//  Created by Justin Brunet on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#include "Kiwi.h"
#include "EVBankAccount.h"

SPEC_BEGIN(EVBankAccountTests)

describe(@"An EVBankAccount", ^{
    
    context(@"to be considered valid", ^{
        
        __block EVBankAccount *bankAccount;
        
        beforeEach(^{
            bankAccount = [[EVBankAccount alloc] initWithDictionary:nil];
            bankAccount.bankName = @"Wells Fargo";
            bankAccount.type = @"Checking";
            bankAccount.routingNumber = @"40274902830";
            bankAccount.accountNumber = @"92874927384";
        });
        
        it(@"should be valid initially", ^{
            [[theValue(bankAccount.isValid) should] equal:theValue(YES)];
        });
        
        it(@"should have a non-empty bankName", ^{
            bankAccount.bankName = @"";
            [[theValue(bankAccount.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have non-empty type", ^{
            bankAccount.type = @"";
            [[theValue(bankAccount.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have a non-empty routingNumber", ^{
            bankAccount.routingNumber = @"";
            [[theValue(bankAccount.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have a non-empty accountNumber", ^{
            bankAccount.accountNumber = @"";
            [[theValue(bankAccount.isValid) should] equal:theValue(NO)];
        });
        
    });
    
});

SPEC_END
