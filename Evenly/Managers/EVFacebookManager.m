//
//  EVFacebookManager.m
//  Evenly
//
//  Created by Justin Brunet on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFacebookManager.h"

@implementation EVFacebookManager

static EVFacebookManager *_sharedManager;

+ (EVFacebookManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [EVFacebookManager new];
    });
    return _sharedManager;
}

#pragma mark - Basics

+ (BOOL)isConnected {
    return FBSession.activeSession.isOpen;
}

+ (void)performRequest:(void (^)(void))request {
    if ([self isConnected])
        request();
    else {
        [self openSessionWithCompletion:request];
    }
}

+ (void)openSessionWithCompletion:(void (^)(void))completion {
    //This method is deprecated, but using it is the only way I could find to force
    //Facebook to use its in-app authentication instead of the native dialog tied to
    //the Facebook info in settings.  The latter is buggy on Facebook's end, which is
    //why most apps don't use it.
    [FBSession openActiveSessionWithPermissions:@[@"basic_info", @"email"]
                                   allowLoginUI:YES
                              completionHandler:[self facebookSessionStateHandlerWithCompletion:completion]];
}

+ (void)quietlyOpenSessionWithCompletion:(void (^)(void))completion {
    [FBSession openActiveSessionWithPermissions:@[@"basic_info", @"email"]
                                   allowLoginUI:NO
                              completionHandler:[self facebookSessionStateHandlerWithCompletion:completion]];
}

+ (FBSessionStateHandler)facebookSessionStateHandlerWithCompletion:(void (^)(void))completion {
    return ^(FBSession *session,
             FBSessionState state, NSError *error) {
        switch (state) {
            case FBSessionStateOpen:
                [self sharedManager].tokenData = session.accessTokenData;
                [self loadFriendsWithCompletion:^(NSArray *friends) {
                    [EVCIA me].facebookFriendCount = [friends count];
                    [[NSUserDefaults standardUserDefaults] setInteger:[friends count] forKey:EVUserFacebookFriendCountKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } failure:^(NSError *error) {
                    DLog(@"Could not load friends: %@", error);
                }];
                if (completion)
                    completion();
                break;
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
                [FBSession.activeSession closeAndClearTokenInformation];
                break;
            default:
                break;
        }
        if (error) {
            NSString *title = nil, *message = nil;
            if ([error code] == FBErrorLoginFailedOrCancelled) {
                title = @"Facebook Login Required";
                message = @"You must login with Facebook to use Evenly.";
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            //These errors stack, so only display the above, or users will see 3 in a row
            
            [self fbResync];
            [NSThread sleepForTimeInterval:0.5];
        }
    };
}

+ (BOOL)hasPublishPermissions {
    return [FBSession.activeSession.permissions containsObject:@"publish_actions"];
}


+ (void)requestPublishPermissionsWithCompletion:(void (^)(void))completion {
    [FBSession openActiveSessionWithPublishPermissions:@[ @"publish_actions" ]
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:[self facebookSessionStateHandlerWithCompletion:completion]];
}

+ (void)closeAndClearSession {
    [[FBSession activeSession] closeAndClearTokenInformation];
}

+ (void)fbResync {
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
            }];
        }
    }
}

#pragma mark - Specifics

+ (void)loadMeWithCompletion:(void (^)(NSDictionary *userDict))completion failure:(void (^)(NSError *error))failure {
    [self performRequest:^{
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *fbError) {
            [self sharedManager].facebookID = user[@"id"];
            if (!fbError) {
                if (completion)
                    completion(user);
            }
            else {
                if (failure)
                    failure(fbError);
            }
        }];
    }];
}

+ (void)loadFriendsWithCompletion:(void (^)(NSArray *friends))completion failure:(void (^)(NSError *error))failure {
    [self performRequest:^{
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSArray *friends = [(NSDictionary *)result objectForKey:@"data"];
                if (completion)
                    completion(friends);
            }
            else {
                if (failure)
                    failure(error);
            }
        }];
    }];
}

@end
