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

+ (CGFloat)cellHeightForStory:(EVStory *)story;

@end
