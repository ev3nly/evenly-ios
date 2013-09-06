//
//  EVDashboardUserCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardUserCell.h"
#import "EVWalletStamp.h"

#define SIDE_MARGIN 20
#define ARROW_CENTER_RIGHT_BUFFER 17
#define AMOUNT_LABELS_MAX_X ([EVUtilities userHasIOS7] ? 284.0 : 275)
#define SMALL_GAP 3.0
#define STAMP_RIGHT_MARGIN 16.0

@interface EVDashboardUserCell ()

@end

@implementation EVDashboardUserCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint center = self.accessoryView.center;
    center.y = self.bounds.size.height / 2.0;
    center.x = self.bounds.size.width - [EVImages dashboardDisclosureArrow].size.width - ARROW_CENTER_RIGHT_BUFFER;
    self.accessoryView.center = center;
    
    if (self.paidStamp)
        [self layoutStamp];
    else
        [self layoutLabels];
}

- (void)layoutStamp {
    self.amountLabel.hidden = YES;

    CGRect paidStampFrame = self.paidStamp.frame;
    paidStampFrame.origin.x = self.contentView.frame.size.width - paidStampFrame.size.width - STAMP_RIGHT_MARGIN;
    paidStampFrame.origin.y = (int)((self.contentView.frame.size.height - paidStampFrame.size.height) / 2.0);
    self.paidStamp.frame = CGRectIntegral(paidStampFrame);
    [self.contentView addSubview:self.paidStamp];
    
    CGFloat maxX = CGRectGetMinX(self.paidStamp.frame) - SMALL_GAP;
    CGRect nameFrame = [self nameLabelFrame];
    nameFrame.size.width = maxX - nameFrame.origin.x;
    self.nameLabel.frame  = nameFrame;
}

- (void)layoutLabels {
    self.amountLabel.hidden = NO;
    self.amountLabel.frame = [self amountLabelFrame];
    
    CGFloat maxX = CGRectGetMinX(self.amountLabel.frame) - SMALL_GAP;
    CGRect nameFrame = [self nameLabelFrame];
    nameFrame.size.width = maxX - nameFrame.origin.x;

    if (!EV_IS_EMPTY_STRING(self.tierLabel.text)) {
        CGFloat height = self.nameLabel.font.lineHeight;
        [self.nameLabel setFrame:CGRectMake(nameFrame.origin.x,
                                            0.5 *self.contentView.frame.size.height - height,
                                            nameFrame.size.width,
                                            height)];
        [self.tierLabel setFrame:CGRectMake(nameFrame.origin.x,
                                            0.5 *self.contentView.frame.size.height,
                                            nameFrame.size.width,
                                            height)];
        
    }
    else {
        self.nameLabel.frame = nameFrame;
    }
}

- (CGRect)amountLabelFrame {
    [self.amountLabel sizeToFit];
    CGRect amountFrame = self.amountLabel.frame;
    amountFrame.origin.y = (self.contentView.frame.size.height - amountFrame.size.height) / 2.0;
    amountFrame.origin.x = AMOUNT_LABELS_MAX_X - amountFrame.size.width;
    return amountFrame;
}

@end
