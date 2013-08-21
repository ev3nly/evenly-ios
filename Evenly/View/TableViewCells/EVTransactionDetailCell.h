//
//  EVTransactionDetailCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryCell.h"

@protocol EVTransactionDetailCellDelegate <NSObject>

- (void)avatarTappedForUser:(EVUser *)user;

@end

@interface EVTransactionDetailCell : EVStoryCell

@property (nonatomic, strong) EVAvatarView *rightAvatarView;
@property (nonatomic, weak) NSObject<EVTransactionDetailCellDelegate> *delegate;

+ (CGFloat)cellHeightForStory:(EVStory *)story;

@end
