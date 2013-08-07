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
                              completionHandler:^(FBSession *session,
                                                  FBSessionState state, NSError *error) {
                                  switch (state) {
                                      case FBSessionStateOpen:
                                          [self sharedManager].tokenData = session.accessTokenData;
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
                                          message  = @"You must login with Facebook to use Evenly.";
                                      } else if ([error fberrorShouldNotifyUser]) {
                                          title = @"Error";
                                          message = error.fberrorUserMessage;
                                      } else {
                                          title = @"Error";
                                          message = error.localizedDescription;
                                      }
                                      [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                      [self fbResync];
                                      [NSThread sleepForTimeInterval:0.5];
                                  }
                              }];
}

+ (BOOL)hasPublishPermissions {
    return [FBSession.activeSession.permissions containsObject:@"publish_actions"];
}


+ (void)requestPublishPermissionsWithCompletion:(void (^)(void))completion {
    [FBSession.activeSession requestNewPublishPermissions:@[ @"publish_actions" ]
                                          defaultAudience:FBSessionDefaultAudienceEveryone
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            if (!error) {
                                                if (completion)
                                                    completion();
                                            }
                                        }];
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
            if (!fbError)
                completion(user);
            else
                failure(fbError);
        }];
    }];
}

+ (void)loadFriendsWithCompletion:(void (^)(NSArray *friends))completion failure:(void (^)(NSError *error))failure {
    [self performRequest:^{
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSArray *friends = [(NSDictionary *)result objectForKey:@"data"];
                completion(friends);
            }
            else
                failure(error);
        }];
    }];
}

@end
