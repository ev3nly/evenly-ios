//
//  EVFacebookManager.m
//  Evenly
//
//  Created by Justin Brunet on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation EVFacebookManager

#pragma mark - Basics

+ (void)performRequest:(void (^)(void))request {
    if (FBSession.activeSession.isOpen)
        request();
    else
        [self openSessionWithCompletion:request];
}

+ (void)openSessionWithCompletion:(void (^)(void))completion {
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         switch (state) {
             case FBSessionStateOpen:
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
             [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             [self fbResync];
             [NSThread sleepForTimeInterval:0.5];
         }
     }];
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

+ (void)loadMeWithCompletion:(void (^)(NSDictionary *userDict))completion {
    [self performRequest:^{
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error)
                completion(user);
            else
                DLog(@"error: %@", error);
        }];
    }];
}

+ (void)loadFriendsWithCompletion:(void (^)(NSArray *friends))completion {
    [self performRequest:^{
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSArray *friends = [(NSDictionary *)result objectForKey:@"data"];
                completion(friends);
            }
            else
                DLog(@"error: %@", error);
        }];
    }];
}

@end
