//
//  EVAvatarToken.h
//  Evenly
//
//  Created by Joseph Hankin on 7/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVAvatarToken : UIView

@property (nonatomic) CGFloat maxWidth;

+ (id)avatarTokenForPerson:(EVObject <EVExchangeable>*)person;
+ (id)avatarTokenForPeople:(NSArray *)people;

@end
