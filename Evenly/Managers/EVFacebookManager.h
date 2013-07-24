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

@property (nonatomic, strong) FBAccessTokenData *tokenData;
@property (nonatomic, strong) NSString *facebookID;

+ (EVFacebookManager *)sharedManager;

+ (BOOL)isConnected;
+ (void)openSessionWithCompletion:(void (^)(void))completion;
+ (void)closeAndClearSession;

+ (void)loadMeWithCompletion:(void (^)(NSDictionary *userDict))completion failure:(void (^)(NSError *error))failure;
+ (void)loadFriendsWithCompletion:(void (^)(NSArray *friends))completion failure:(void (^)(NSError *error))failure;

@end
