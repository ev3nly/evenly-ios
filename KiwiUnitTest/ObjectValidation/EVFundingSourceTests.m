//
//  EVFundingSourceTests.m
//  Evenly
//
//  Created by Justin Brunet on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#include "Kiwi.h"
#include "EVFundingSource.h"

SPEC_BEGIN(EVFundingSourceTests)

describe(@"An EVFundingSource", ^{
    
    context(@"to be valid", ^{
        
        __block EVFundingSource *fundingSource;
        
        beforeEach(^{
            fundingSource = [[EVFundingSource alloc] initWithDictionary:nil];
            fundingSource.uri = @"http://evenly.com/";
        });
        
        it(@"should be valid initially", ^{
            [[theValue(fundingSource.isValid) should] equal:theValue(YES)];
        });
        
        it(@"should have a uri", ^{
            fundingSource.uri = nil;
            [[theValue(fundingSource.isValid) should] equal:theValue(NO)];
        });
        
    });
    
});

SPEC_END
