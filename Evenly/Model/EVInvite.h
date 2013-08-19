//
//  EVInvite.h
//  Evenly
//
//  Created by Sean Yu on 4/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVInvite : EVObject

+ (void)createWithEmail:(NSString *)email success:(void (^)(EVObject *object))success failure:(void(^)(NSError *error))failure;
+ (void)createWithEmails:(NSArray *)emails success:(void (^)(EVObject *object))success failure:(void(^)(NSError *error))failure;

+ (void)createWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(EVObject *object))success failure:(void(^)(NSError *error))failure;
@end
