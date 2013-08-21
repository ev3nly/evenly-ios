//
//  EVWalletCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletCell.h"
#import "EVSpreadLabel.h"

@implementation EVWalletCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(EV_RIGHT_OVERHANG_MARGIN, 0, self.contentView.frame.size.width - EV_RIGHT_OVERHANG_MARGIN, self.contentView.frame.size.height)];
        containerView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        containerView.autoresizesSubviews = YES;
        [self.contentView addSubview:containerView];

        self.containerView = containerView;
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


@implementation EVWalletSectionHeader

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[EVColor sidePanelHeaderBackgroundColor]];
        CGFloat margin = 12.0;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(EV_RIGHT_OVERHANG_MARGIN, 0, self.contentView.frame.size.width - EV_RIGHT_OVERHANG_MARGIN, self.contentView.frame.size.height)];
        containerView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        containerView.autoresizesSubviews = YES;
        [self.contentView addSubview:containerView];
        self.label = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(margin,
                                                                    0.0,
                                                                    containerView.frame.size.width / 2.0 - margin,
                                                                    containerView.frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor sidePanelTextColor];
        self.label.font = [EVFont walletHeaderFont];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [(EVSpreadLabel *)self.label setCharacterSpacing:2.0];
        [containerView addSubview:self.label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
