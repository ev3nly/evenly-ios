//
//  EVSessionTest.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/2/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "Kiwi.h"
#import "EVSession.h"
#import "EVError.h"
#import "EVNetworkManager.h"


SPEC_BEGIN(EVSessionTest)

describe(@"EVSession", ^{
   
    describe(@"create", ^{
       
        it(@"grabs and sets authentication token as the Authorization Header", ^{
           
            __block NSString *token = nil;
            
            /*[EVSession createWithEmail:@"seansu4you87@gmail.com" password:@"haisean" success:^(void){
                
                token = [EVSession sharedSession].authenticationToken;
                
            } failure:^(NSError *error){}];*/
            
            [KWSpec loginWithEmail:@"seansu4you87@gmail.com" password:@"haisean" andSuccess:^(KillWait killer){
               
                token = [EVSession sharedSession].authenticationToken;
                killer();
                
            }];
            
            [[expectFutureValue(token) shouldEventually] beNonNil];
            [[expectFutureValue([[EVNetworkManager sharedInstance].httpClient defaultValueForHeader:@"Authorization"]) shouldEventually] equal:token];
            
        });
        
        context(@"incorrect credentials", ^{
            
            it(@"raises error", ^{
               
                __block EVError *theError = nil;
                
                [EVSession createWithEmail:@"seansu4you87@gmail.com" password:@"fawoi" success:^(void){} failure:^(NSError *error){
                    
                    theError = (EVError *)error;
                    
                }];
                
                [[expectFutureValue([NSNumber numberWithInt:theError.code]) shouldEventually] equal:theValue(404)];
                
            });
            
        });
        
    });
    
    describe(@"destroy", ^{
       
        it(@"sets the shared session to nil and removes the Authorization Header", ^{
           
            [EVSession createWithEmail:@"seansu4you87@gmail.com" password:@"haisean" success:^(void){
                
                [[EVSession sharedSession] destroyWithSuccess:^(void){} failure:^(NSError *error){}];
                
            } failure:^(NSError *error){}];
            
            [[expectFutureValue([EVSession sharedSession]) shouldEventually] beNil];
            [[expectFutureValue([[EVNetworkManager sharedInstance].httpClient defaultValueForHeader:@"Authorization"]) shouldEventually] beNil];
            
        });
        
    });
    
});

SPEC_END