//
//  EVDashboardUserCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardUserCell.h"
#import "EVWalletStamp.h"

#define AMOUNT_LABELS_MAX_X 275.0
#define SMALL_GAP 3.0
#define STAMP_RIGHT_MARGIN 15.0

@interface EVDashboardUserCell ()

@end

@implementation EVDashboardUserCell

+ (UILabel *)configuredNoTierLabel {
    UILabel *noTierLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noTierLabel.backgroundColor = [UIColor clearColor];
    noTierLabel.textColor = [EVColor lightLabelColor];
    noTierLabel.font = [EVFont defaultFontOfSize:15.0];
    noTierLabel.text = @"Set amount";
    [noTierLabel sizeToFit];
    return noTierLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadAmountLabel];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[EVImages dashboardDisclosureArrow]];

    }
    return self;
}

- (void)loadAmountLabel {
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.font = [EVFont boldFontOfSize:15];
    self.amountLabel.textColor = [EVColor lightGreenColor];
    self.amountLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.amountLabel];
}

- (void)setPaidStamp:(EVWalletStamp *)paidStamp {
    if (_paidStamp) {
        [_paidStamp removeFromSuperview];
    }
    _paidStamp = paidStamp;
}

- (void)setNoTierLabel:(UILabel *)noTierLabel {
    if (_noTierLabel)
        [_noTierLabel removeFromSuperview];
    _noTierLabel = noTierLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.paidStamp)
    {
        [self layoutStamp];
    }
    else if (self.noTierLabel)
    {
        [self layoutNoTierLabel];
    }
    else
    {
        [self layoutLabels];
    }
}

- (void)layoutStamp {
    self.amountLabel.hidden = YES;

    CGRect paidStampFrame = self.paidStamp.frame;
    paidStampFrame.origin.x = self.contentView.frame.size.width - paidStampFrame.size.width - STAMP_RIGHT_MARGIN;
    paidStampFrame.origin.y = (int)((self.contentView.frame.size.height - paidStampFrame.size.height) / 2.0);
    self.paidStamp.frame = paidStampFrame;
    [self.contentView addSubview:self.paidStamp];
    
    CGFloat maxX = CGRectGetMinX(self.paidStamp.frame) - SMALL_GAP;
    [self.nameLabel setFrame:CGRectMake(GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                        0,
                                        maxX - GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                        self.contentView.frame.size.height)];
}

- (void)layoutNoTierLabel {
    self.amountLabel.hidden = YES;
    
    CGRect noTierFrame = self.noTierLabel.frame;
    noTierFrame.origin.x = AMOUNT_LABELS_MAX_X - noTierFrame.size.width;
    noTierFrame.origin.y = (int)((self.contentView.frame.size.height - noTierFrame.size.height) / 2.0);
    self.noTierLabel.frame = noTierFrame;
    [self.contentView addSubview:self.noTierLabel];
    
    CGFloat maxX = CGRectGetMinX(self.noTierLabel.frame) - SMALL_GAP;
    [self.nameLabel setFrame:CGRectMake(GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                        0,
                                        maxX - GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                        self.contentView.frame.size.height)];
}

- (void)layoutLabels {
    self.amountLabel.hidden = NO;
    [self.amountLabel sizeToFit];
    
    CGFloat totalHeight = self.amountLabel.frame.size.height;
    CGFloat yOrigin = (self.contentView.frame.size.height - totalHeight) / 2.0;
    [self.amountLabel setOrigin:CGPointMake(AMOUNT_LABELS_MAX_X - self.amountLabel.frame.size.width, yOrigin)];
    
    CGFloat maxX = CGRectGetMinX(self.amountLabel.frame) - SMALL_GAP;
    
    if (!EV_IS_EMPTY_STRING(self.tierLabel.text))
    {
        CGFloat height = self.nameLabel.font.lineHeight;
        [self.nameLabel setFrame:CGRectMake(GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            0.5 *self.contentView.frame.size.height - height,
                                            maxX - GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            height)];
        [self.tierLabel setFrame:CGRectMake(GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            0.5 *self.contentView.frame.size.height,
                                            maxX - GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            height)];
        
    }
    else
    {
        [self.nameLabel setFrame:CGRectMake(GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            0,
                                            maxX - GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            self.contentView.frame.size.height)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
