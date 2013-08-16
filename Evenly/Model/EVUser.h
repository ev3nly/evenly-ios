//
//  EVUser.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

#define EV_USER_DEFAULT_AVATAR_HEIGHT 80
#define EV_USER_TAKEN_AVATAR_BOUNDING_SIZE CGSizeMake(200, 200) 

/*
 
 EVAvatarOwning - protocol that defines needed properties for avatar data
 
 */

@protocol EVAvatarOwning <NSObject>

@property (nonatomic, readonly) UIImage *avatar;
@property (nonatomic, strong) NSURL *avatarURL;

@end

/* 
 
 EVExchangeable - protocol that defines needed properties for Payment and Request

 */

@protocol EVExchangeable <EVAvatarOwning>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneNumber;

@end


/*
 
 EVUser
 
 */

@interface EVUser : EVObject<EVExchangeable, NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSDecimalNumber *balance;
@property (nonatomic, strong) UIImage *updatedAvatar;
@property (nonatomic, assign) EVPrivacySetting privacySetting;
@property (nonatomic, assign) BOOL rewardSharingSetting;
@property (nonatomic, strong) NSArray *connections;
@property (nonatomic, strong) NSString *currentPassword;
@property (nonatomic) BOOL facebookConnected;
@property (nonatomic, strong) NSArray *roles;

@property (nonatomic, readonly) BOOL needsGettingStartedHelp;
@property (nonatomic, readonly) BOOL needsPaymentHelp;
@property (nonatomic, readonly) BOOL needsRequestHelp;
@property (nonatomic, readonly) BOOL needsDepositHelp;

@property (nonatomic, getter = isUnconfirmed) BOOL unconfirmed;
@property (nonatomic, readonly) BOOL hasAddedCard;
@property (nonatomic, readonly) BOOL hasAddedBank;
@property (nonatomic, readonly) BOOL hasSentPayment;
@property (nonatomic, readonly) BOOL hasSentRequest;
@property (nonatomic, readonly) BOOL hasInvitedFriends;

+ (void)meWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure reload:(BOOL)reload;
+ (void)updateMeWithFacebookToken:(NSString *)token
                       facebookID:(NSString *)facebookID
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure;

+ (void)newsfeedWithSuccess:(void (^)(NSArray *newsfeed))success
                    failure:(void (^)(NSError *error))failure;
+ (void)newsfeedStartingAtPage:(int)pageNumber
                       success:(void (^)(NSArray *newsfeed))success
                       failure:(void (^)(NSError *error))failure;
+ (void)historyStartingAtPage:(int)pageNumber
                      success:(void (^)(NSArray *history))success
                      failure:(void (^)(NSError *error))failure;
+ (void)pendingWithSuccess:(void (^)(NSArray *pending))success
                   failure:(void (^)(NSError *error))failure;

+ (void)loadUser:(EVUser *)user withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

+ (void)resetPasswordForEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
+ (void)sendConfirmationEmailWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

- (void)loadAvatar;
- (void)evictAvatarFromCache;

- (void)timelineWithSuccess:(void (^)(NSArray *timeline))success failure:(void (^)(NSError *error))failure;

@end


/*
 
 EVContact - Used to represent server's SignUpContact
 Only used in EVExchange
 
 */

@interface EVContact : EVObject<EVExchangeable>

@end