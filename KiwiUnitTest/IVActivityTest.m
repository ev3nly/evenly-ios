//
//  EVActivityTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/3/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVActivity.h"

SPEC_BEGIN(EVActivityTest)

describe(@"all", ^{
   
    it(@"gets the currently logged in User's recent activity", ^{
       
        __block NSDictionary *activity = nil;
        
        [KWSpec loginWithEmail:@"seansu4you87@gmail.com" password:@"haisean" andSuccess:^(KillWait killer) {
            
           [EVActivity allWithSuccess:^(id result) {
               
               activity = result;
               killer();
               
           } failure:^(NSError *error) {
               killer();
           }];
            
        }];
        
        [[expectFutureValue(activity) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        
    });
    
});

SPEC_END
