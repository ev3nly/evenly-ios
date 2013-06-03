#import "Kiwi.h"
#import "KWSpec+Helper.h"
#import "EVUser.h"
#import "EVError.h"

SPEC_BEGIN(EVUserTest)

describe(@"EVUser", ^{
    registerMatchers(@"BG"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    describe(@"save", ^{
        
        context(@"User already exists", ^{
            
            it(@"should raise a Validation Error", ^{
                
                __block EVError *theError = nil;
                
                EVUser *sean = [[EVUser alloc] initWithDictionary: @{
                                @"name":            @"Sean Yu",
                                @"email":           @"seansu4you87@gmail.com",
                                @"phone_number":    @"8592839203",
                                @"password":        @"haisean" }];
                [sean saveWithSuccess:^(void){
                
                    
                
                } failure:^(NSError *error){
                    
                    theError = (EVError *)error;
                    
                }];
                
                [[expectFutureValue(theError) shouldEventually] beNonNil];
                [[expectFutureValue([NSNumber numberWithInt:theError.code]) shouldEventually] equal:theValue(422)];
                [[expectFutureValue(theError.message) shouldEventually] equal:@"Validation Failed"];
                
            });
            
        });
        
    });
    
    describe(@"allWithQuery", ^{
       
        it(@"gets an array of Users that could match the query", ^{
           
            __block NSArray *users = nil;
            
            [KWSpec loginWithEmail:@"buyer@paywithivy.com" password:@"testmenow" andSuccess:^(KillWait killer) {
                [EVUser allWithParams:@{@"query": @"ean"} success:^(id result) {
                    
                    users = result;
                    killer();
                    
                } failure:^(NSError *error) {
                    killer();
                }];
            }];
            
            [[expectFutureValue(users) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
            
        });
        
    });
    
    describe(@"GET /me", ^{
       
        it(@"grabs the currently logged in User from the server", ^{
           
            [KWSpec loginWithEmail:@"seansu4you87@gmail.com" password:@"haisean" andSuccess:^(KillWait killer){
               
                [EVUser meWithSuccess:^{
                    
                    killer();
                    
                } failure:^(NSError *error){
                    
                    killer();
                    
                } reload:YES];
                
            }];
            
            [[expectFutureValue([EVUser me].email) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:@"seansu4you87@gmail.com"];
            
        });
        
    });
    
    describe(@"PUT /me", ^{
       
        it(@"updates the currently logged in User", ^{
           
            __block NSString *name = nil;
            
            [KWSpec loginWithEmail:@"seansu4you87@gmail.com" password:@"haisean" andSuccess:^(KillWait killer){
               
                [EVUser meWithSuccess:^{
                    
                    EVUser *me = [EVUser me];
                    me.name = @"Bombadil";
                    
                    [me updateWithSuccess:^{
                        
                        name = me.name;
                        killer();
                        
                    } failure:^(NSError *error){
                        error = (EVError *)error;
                        killer();
                    }];
                    
                } failure:^(NSError *error){
                    killer();
                } reload:YES];
                
            }];
            
            [[expectFutureValue(name) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
            
        });
        
    });
    
});

SPEC_END