//
//  EVAvatarView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVUser.h"

@interface EVAvatarView : UIView

+ (CGSize)avatarSize;

@property (nonatomic, weak) NSObject<EVAvatarOwning> *avatarOwner;
@property (nonatomic, strong) UIImage *image;

@end
