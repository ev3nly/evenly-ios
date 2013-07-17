//
//  EVUser.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

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
@property (nonatomic, getter = isConfirmed) BOOL confirmed;
@property (nonatomic, assign) EVPrivacySetting privacySetting;
@property (nonatomic, strong) NSArray *connections;

+ (EVUser *)me;
+ (void)setMe:(EVUser *)user;
+ (void)meWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure reload:(BOOL)reload;
+ (void)saveMeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
+ (void)newsfeedWithSuccess:(void (^)(NSArray *newsfeed))success failure:(void (^)(NSError *error))failure;
+ (void)loadUser:(EVUser *)user withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

- (void)loadAvatar;
- (void)evictAvatarFromCache;

- (void)timelineWithSuccess:(void (^)(NSArray *timeline))success failure:(void (^)(NSError *error))failure;

@end


/*
 
 EVContact - Used to represent server's SignUpContact
 Only used in EVExchange
 
 */

@interface EVContact : EVObject<EVExchangeable>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSString *email;

@end