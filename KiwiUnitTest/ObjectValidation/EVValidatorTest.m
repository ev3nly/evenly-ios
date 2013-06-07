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

describe(@"For EVValidator", ^{
    
    context(@"a valid email", ^{
        
        EVValidator *validator = [EVValidator sharedValidator];
        __block NSString *email;
        
        beforeEach(^{
            email = nil;
        });
        
        it(@"should have a .", ^{
            email = @"hey";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have an @", ^{
            email = @"hey@COM";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have an @ before a .", ^{
            email = @"justin.paywithivy@com";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have text before the @", ^{
            email = @"@ivy.com";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have text after the .", ^{
            email = @"justin@ivy.";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have text between the @ and .", ^{
            email = @"justin@.com";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have at least 2 characters after the .", ^{
            email = @"justin@hey.i";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"should have no more than 4 characters after the .", ^{
            email = @"justin@test.whatup";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(NO)];
        });
        
        it(@"can have a _ in the beginning", ^{
            email = @"justin_brunet@even.ly";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
        it(@"can have a . in the beginning", ^{
            email = @"justin.brunet@gmail.com";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
        it(@"can be in all caps", ^{
            email = @"JUSTIN@OH.NO";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
        it(@"can be pretty short", ^{
            email = @"a@a.ly";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
        it(@"can have a four letter domain", ^{
            email = @"justin@evenly.info";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
        it(@"can have a two part domain", ^{
            email = @"justin@evenly.co.uk";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
        it(@"can have a tag", ^{
            email = @"justin+brunet@gmail.com";
            BOOL isValid = [validator stringIsValidEmail:email];
            [[theValue(isValid) should] equal:theValue(YES)];
        });
        
    });
});

SPEC_END