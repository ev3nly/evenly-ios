//
//  EVGroupRequestTierAssignmentViewCell.h
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVAvatarView.h"

@interface EVGroupRequestTierAssignmentViewCell : UICollectionViewCell

@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *captionLabel;
@property (nonatomic, strong) UIImageView *selectionIndicator;

- (void)setContact:(EVObject<EVExchangeable> *)contact;

@end
