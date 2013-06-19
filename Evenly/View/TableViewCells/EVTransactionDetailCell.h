//
//  EVTransactionDetailCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryCell.h"

@interface EVTransactionDetailCell : EVStoryCell

@property (nonatomic, strong) EVAvatarView *rightAvatarView;
@property (nonatomic, strong) UIImageView *incomeIcon;

+ (CGFloat)cellHeightForStory:(EVStory *)story;

@end
