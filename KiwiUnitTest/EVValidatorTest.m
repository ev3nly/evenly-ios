//
//  EVValidatorTest.m
//  Evenly
//
//  Created by Justin Brunet on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "Kiwi.h"
#import "EVValidator.h"

SPEC_BEGIN(EVValidatorTest)

describe(@"EVValidator", ^{
    
    context(@"email validation", ^{
        
        __block EVValidator *validator;
        __block NSString *email;
        
        beforeAll(^{
            validator = [EVValidator sharedValidator];
        });
        
        beforeEach(^{
            email = nil;
        });
       
        it(@"should reject this", ^{
            email = @"hey";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should accept this", ^{
            email = @"justin@paywithivy.com";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
    });
});

SPEC_END