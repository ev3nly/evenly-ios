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
    
    context(@"when validating emails", ^{
        
        __block EVValidator *validator;
        
        beforeAll(^{
            validator = [EVValidator sharedValidator];
        });
       
        it(@"should reject these", ^{
            
            NSArray *emails = @[ @"hey",
                                 @"hey.com",
                                 @"hey@COM",
                                 @"justin.paywithivy@com",
                                 @"@ivy.com",
                                 @"justin@ivy.",
                                 @"justin@.com",
                                 @"@.",
//                                 @"justin@test.whatubhlj",
                                 @"justin@hey.i" ];
            
            for (NSString *email in emails) {
                BOOL isValid = [validator stringIsValidEmail:email];
                [[theValue(isValid) should] equal:theValue(NO)];
            }
        });
        
        it(@"should accept these", ^{
            NSArray *emails = @[ @"justin@paywithivy.com",
                                 @"ju_stin@even.ly",
                                 @"j%b@oh.no",
                                 @"JUSTIN@yo.no",
                                 @"justin@HEY.COM",
                                 @"yo@bit.ly",
                                 @"sup@me.co.uk",
                                 @"hello@s.info" ];
            
            for (NSString *email in emails) {
                BOOL isValid = [validator stringIsValidEmail:email];
                [[theValue(isValid) should] equal:theValue(YES)];
            }
        });
        
    });
});

SPEC_END