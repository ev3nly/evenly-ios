//
//  EVApplicationErrorHandler.m
//  IvyPrototype
//
//  Created by Sean Yu on 4/10/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

#import "EVAppErrorHandler.h"
#import "EVAppDelegate.h"
#import "EVNetworkManager.h"
#import "EVNavigationManager.h"

#import "EVSession.h"
#import "EVUser.h"
#import "EVCIA.h"

#import "EVActivity.h"

#import "EVSerializer.h"

static BOOL _handling418;

@interface EVAppErrorHandler(private)

+ (void)handle401:(EVError *)e401
       forOperation:(EVJSONRequestOperation *)operation
withOriginalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
    originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure;

+ (void)handle418:(EVError *)e418
     forOperation:(EVJSONRequestOperation *)operation
  originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
  originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure;

+ (void)handle419:(EVError *)e419
     forOperation:(EVJSONRequestOperation *)operation
  originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
  originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure;

#pragma mark - Helpers

+ (void (^)(void))replayRequestBlockForOperation:(EVJSONRequestOperation *)operation
                                 originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
                                 originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure;

+ (void (^)(void))showLoginBlockWithAuthenticationSuccess:(void(^)(void))authenticationSuccess;

@end

@implementation EVAppErrorHandler 

+ (void)handleError:(EVError *)error
       forOperation:(EVJSONRequestOperation *)operation
withOriginalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
    originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure {
    
    switch ([error code]) {
        case 0:
            DLog(@"ERROR CODE 0 wtf");
            break;
        case 401: // Unauthorized
            [self handle401:error forOperation:operation originalSuccess:originalSuccess originalFailure:originalFailure];
            break;
        case 418: // I'm a teapot
            [self handle418:error forOperation:operation originalSuccess:originalSuccess originalFailure:originalFailure];
            break;
        case 419: // Unconfirmed user
            [self handle419:error forOperation:operation originalSuccess:originalSuccess originalFailure:originalFailure];
            break;
        case 503: // Service Unavailable
            [[[UIAlertView alloc] initWithTitle:[EVStringUtility appName] message:[EVStringUtility serverMaintenanceError] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            break;
        default:
			[[[UIAlertView alloc] initWithTitle:error.message message:error.errorMessages delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            originalFailure(operation, error);
            break;
    }
}

+ (void)handle401:(EVError *)e401
     forOperation:(EVJSONRequestOperation *)operation
  originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
  originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure {
	
	void (^replayRequest)(void) = [self replayRequestBlockForOperation:operation
                                                       originalSuccess:originalSuccess
                                                       originalFailure:originalFailure];
	
	void (^showLogin)(void) = [self showLoginBlockWithAuthenticationSuccess:replayRequest];

    //no cached user, get credentials, reauthenticate
    EVUser *me = [EVUser me];
    if (me.email == nil || me.password == nil) {
        [[EVCIA sharedInstance] setSession:nil];
		showLogin();
        return;
    }
    
    //cached user exists, use cached creds to reauthenticate
    [EVSession createWithEmail:me.email password:me.password success:^{
        //success!  cache session, replay request
        [[EVCIA sharedInstance] setSession:[EVSession sharedSession]];
		replayRequest();
        
    } failure:^(NSError *error) {
        //failure, get credentials, reauthenticate
		showLogin();
    }];
}

+ (void)handle418:(EVError *)e418
     forOperation:(EVJSONRequestOperation *)operation
  originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
  originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure {
    
//    [[EVAppDelegate masterViewController] showKillswitchWithTitle:e418.userInfo[@"title"]
//                                                          message:e418.userInfo[@"description"]
//                                                        urlString:e418.userInfo[@"url"]];
    
//    [NSTimer scheduledTimerWithTimeInterval:5.0 block:^{
//        
//        NSLog(@"checking to see if killswitch has been disabled");
//        [EVUser meWithSuccess:^{
//            [[EVAppDelegate masterViewController] dismissKillswitch];
//            _handling418 = NO;
//        } failure:nil reload:YES];
//        
//    } repeats:NO];
    
    _handling418 = YES;
}

+ (void)handle419:(EVError *)e419
             forOperation:(EVJSONRequestOperation *)operation
          originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
  originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure {
    originalFailure(operation, e419);
}

# pragma mark - Helpers

+ (void (^)(void))replayRequestBlockForOperation:(EVJSONRequestOperation *)operation
                                 originalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
                                 originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure {
    
    return ^{
		/*
         copy original RequestOperation's request
         reset Authorization header to new value from the shared Session
         clone RequestOperation with the original success and failure blocks
         re-enqueue RequestOperation
         */
		EVHTTPClient *httpClient = [[EVNetworkManager sharedInstance] httpClient];
        NSMutableURLRequest *request = [operation.request copy];
        [request setValue:[EVSession sharedSession].authenticationToken forHTTPHeaderField:@"Authorization"];
        
        EVJSONRequestOperation *clonedOperation = (EVJSONRequestOperation *)[httpClient HTTPRequestOperationWithRequest:request
                                                                                                                success:originalSuccess
                                                                                                                failure:originalFailure
                                                                                                          hijackFailure:NO];
		
        [[EVNetworkManager sharedInstance] enqueueRequest:clonedOperation];
	};
}

+ (void (^)(void))showLoginBlockWithAuthenticationSuccess:(void(^)(void))authenticationSuccess {
    return ^{
		[[[EVNavigationManager sharedManager] masterViewController] showLoginViewControllerWithCompletion:^{
			[[EVCIA sharedInstance] setSession:nil];
			[[EVCIA sharedInstance] setMe:nil];
		} animated:YES authenticationSuccess:^{
			if (authenticationSuccess)
                authenticationSuccess();
		}];
	};
}

@end
