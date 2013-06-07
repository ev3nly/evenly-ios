//
//  EVExchangeTests.m
//  Evenly
//
//  Created by Justin Brunet on 6/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "Kiwi.h"
#import "EVExchange.h"
#import "EVUser.h"

SPEC_BEGIN(EVExchangeTests)

describe(@"An EVExchange", ^{
    
    context(@"to be considered valid", ^{
        
        __block EVExchange *exchange;
        
        beforeEach(^{
            exchange = [[EVExchange alloc] initWithDictionary:nil];
            exchange.amount = [NSDecimalNumber decimalNumberWithString:@"14.87"];
            exchange.memo = @"Sai's";
            
            EVObject<EVExchangeable> *toPerson = [EVUser new];
            toPerson.name = @"Joe Hankin";
            toPerson.email = @"joe@paywithivy.com";
            exchange.to = toPerson;
            
            EVObject<EVExchangeable> *fromPerson = [EVUser new];
            fromPerson.name = @"Justin Brunet";
            fromPerson.email = @"justin@paywithivy.com";
            exchange.from = fromPerson;            
        });
        
        it(@"should be valid initially", ^{
            [[theValue(exchange.isValid) should] equal:theValue(YES)];
        });
        
        it(@"should have a non-nil amount", ^{
            exchange.amount = nil;
            [[theValue(exchange.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have an amount that is not NaN", ^{
            exchange.amount = [NSDecimalNumber decimalNumberWithString:@""];
            [[theValue(exchange.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have an amount greater than 0", ^{
            exchange.amount = [NSDecimalNumber decimalNumberWithString:@"0"];
            [[theValue(exchange.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have a memo", ^{
            exchange.memo = @"";
            [[theValue(exchange.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have a non-nil to", ^{
            exchange.to = nil;
            [[theValue(exchange.isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have a non-nil from", ^{
            exchange.from = nil;
            [[theValue(exchange.isValid) should] equal:theValue(NO)];
        });
        
    });
    
});

SPEC_END
