//
//  EVAvatarToken.h
//  Evenly
//
//  Created by Joseph Hankin on 7/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EV_AVATAR_TOKEN_MAX_WIDTH 190.0

@interface EVAvatarToken : UIView

+ (id)avatarTokenForPerson:(EVObject <EVExchangeable>*)person;
+ (id)avatarTokenForPeople:(NSArray *)people;

@end
