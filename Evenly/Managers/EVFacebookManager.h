//
//  EVFacebookManager.h
//  Evenly
//
//  Created by Justin Brunet on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface EVFacebookManager : NSObject

extern NSString *const EVFacebookManagerDidLogInNotification;
extern NSString *const EVFacebookManagerDidLogOutNotification;

@property (nonatomic, strong) FBAccessTokenData *tokenData;
@property (nonatomic, strong) NSString *facebookID;

+ (EVFacebookManager *)sharedManager;

#pragma mark - Signup Pathway

+ (void)openSessionForSignupWithCompletion:(void (^)(void))completion;
+ (void)loadMeForSignupWithCompletion:(void (^)(NSDictionary *userDict))completion failure:(void (^)(NSError *error))failure;

#pragma mark - Ordinary Requests
+ (BOOL)isConnected;
+ (void)openSessionWithCompletion:(void (^)(void))completion;
+ (void)quietlyOpenSessionWithCompletion:(void (^)(void))completion;

+ (BOOL)hasPublishPermissions;
+ (void)requestPublishPermissionsWithCompletion:(void (^)(void))completion;

+ (void)closeAndClearSession;

+ (void)loadMeWithCompletion:(void (^)(NSDictionary *userDict))completion failure:(void (^)(NSError *error))failure;
+ (void)loadFriendsWithCompletion:(void (^)(NSArray *friends))completion failure:(void (^)(NSError *error))failure;

#pragma mark - Close Friends

+ (void)loadCloseFriendsWithCompletion:(void (^)(NSArray *closeFriends))completion failure:(void (^)(NSError *error))failure;

@end
