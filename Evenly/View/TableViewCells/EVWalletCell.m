//
//  EVWalletCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletCell.h"

@implementation EVWalletCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat margin = 12.0;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(EV_RIGHT_OVERHANG_MARGIN, 0, self.contentView.frame.size.width - EV_RIGHT_OVERHANG_MARGIN, self.contentView.frame.size.height)];
        containerView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        containerView.autoresizesSubviews = YES;
        [self.contentView addSubview:containerView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,
                                                                       0.0,
                                                                       containerView.frame.size.width / 2.0 - margin,
                                                                       containerView.frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [EVFont boldFontOfSize:20.0];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [containerView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(containerView.frame.size.width / 2.0,
                                                                    0.0,
                                                                    containerView.frame.size.width / 2.0 - margin,
                                                                    containerView.frame.size.height)];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textColor = [UIColor whiteColor];
        self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        self.valueLabel.font = [EVFont defaultFontOfSize:20.0];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        [containerView addSubview:self.valueLabel];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WalletArrow"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
