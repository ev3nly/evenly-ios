//
//  EVUser.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

/* 
 
 EVExchangeable - protocol that defines needed properties for Payment and Charge

 */

@protocol EVExchangeable <NSObject>

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
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, readonly) UIImage *avatar;
@property (nonatomic, strong) UIImage *updatedAvatar;
@property (nonatomic, getter = isConfirmed) BOOL confirmed;

+ (EVUser *)me;
+ (void)setMe:(EVUser *)user;
+ (void)meWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure reload:(BOOL)reload;
+ (void)saveMeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

- (void)loadAvatar;
- (void)evictAvatarFromCache;

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