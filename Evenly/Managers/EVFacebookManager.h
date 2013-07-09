//
//  EVFacebookManager.h
//  Evenly
//
//  Created by Justin Brunet on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVFacebookManager : NSObject

+ (void)loadMeWithCompletion:(void (^)(NSDictionary *userDict))completion;
+ (void)loadFriendsWithCompletion:(void (^)(NSArray *friends))completion;

@end
