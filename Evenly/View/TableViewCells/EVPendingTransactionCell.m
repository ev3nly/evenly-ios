//
//  EVPendingTransactionCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingTransactionCell.h"

@implementation EVPendingTransactionCell

+ (CGSize)sizeForTransaction:(EVExchange *)exchange {
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGFloat margin = 10.0;
        CGFloat dimension = self.frame.size.height - 2*margin;
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(margin, margin, 44, 44)];
//        self.avatarView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self.containerView addSubview:self.avatarView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
