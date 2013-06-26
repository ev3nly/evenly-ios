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


- (void)loadOwesLabels;
- (void)loadPaidLabels;

@end

@implementation EVDashboardUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadOwesLabels];
        [self loadPaidLabels];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];

    }
    return self;
}

- (void)loadOwesLabels {
    self.owesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.owesLabel.text = @"Owes";
    self.owesLabel.font = [EVFont boldFontOfSize:GROUP_REQUEST_USER_CELL_SMALL_FONT_SIZE];
    self.owesLabel.textColor = [EVColor lightLabelColor];
    self.owesLabel.backgroundColor = [UIColor clearColor];
    [self.owesLabel sizeToFit];
    [self.contentView addSubview:self.owesLabel];

    self.owesAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.owesAmountLabel.font = [EVFont defaultFontOfSize:GROUP_REQUEST_USER_CELL_SMALL_FONT_SIZE];
    self.owesAmountLabel.backgroundColor = [UIColor clearColor];
    self.owesAmountLabel.textColor = [EVColor lightRedColor];
    [self.contentView addSubview:self.owesAmountLabel];
}

- (void)loadPaidLabels {
    self.paidLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.paidLabel.text = @"Paid";
    self.paidLabel.font = [EVFont boldFontOfSize:GROUP_REQUEST_USER_CELL_SMALL_FONT_SIZE];
    self.paidLabel.textColor = [EVColor lightLabelColor];
    self.paidLabel.backgroundColor = [UIColor clearColor];
    [self.paidLabel sizeToFit];
    [self.contentView addSubview:self.paidLabel];
    
    self.paidAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.paidAmountLabel.font = [EVFont defaultFontOfSize:GROUP_REQUEST_USER_CELL_SMALL_FONT_SIZE];
    self.paidAmountLabel.backgroundColor = [UIColor clearColor];
    self.paidAmountLabel.textColor = [EVColor lightGreenColor];
    [self.contentView addSubview:self.paidAmountLabel];
}

- (void)setPaidStamp:(EVWalletStamp *)paidStamp {
    if (_paidStamp) {
        [_paidStamp removeFromSuperview];
    }
    _paidStamp = paidStamp;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.paidStamp)
    {
        [self layoutStamp];
    }
    else
    {
        [self layoutLabels];
    }
}

- (void)layoutStamp {
    self.owesLabel.hidden = YES;
    self.paidLabel.hidden = YES;
    self.owesAmountLabel.hidden = YES;
    self.paidAmountLabel.hidden = YES;

    CGRect paidStampFrame = self.paidStamp.frame;
    paidStampFrame.origin.x = self.contentView.frame.size.width - paidStampFrame.size.width - STAMP_RIGHT_MARGIN;
    paidStampFrame.origin.y = (int)((self.contentView.frame.size.height - paidStampFrame.size.height) / 2.0);
    self.paidStamp.frame = paidStampFrame;
    [self.contentView addSubview:self.paidStamp];
}

- (void)layoutLabels {
    self.owesLabel.hidden = NO;
    self.paidLabel.hidden = NO;
    self.owesAmountLabel.hidden = NO;
    self.paidAmountLabel.hidden = NO;
    
    [self.owesAmountLabel sizeToFit];
    [self.paidAmountLabel sizeToFit];
    
    CGFloat totalHeight = self.owesAmountLabel.frame.size.height + self.paidAmountLabel.frame.size.height;
    CGFloat yOrigin = (self.contentView.frame.size.height - totalHeight) / 2.0;
    [self.owesAmountLabel setOrigin:CGPointMake(AMOUNT_LABELS_MAX_X - self.owesAmountLabel.frame.size.width,
                                                yOrigin)];
    [self.paidAmountLabel setOrigin:CGPointMake(AMOUNT_LABELS_MAX_X - self.paidAmountLabel.frame.size.width,
                                                CGRectGetMaxY(self.owesAmountLabel.frame))];
    
    CGFloat maxAmountWidth = MAX(self.owesAmountLabel.frame.size.width, self.paidAmountLabel.frame.size.width);
    CGFloat maxLabelWidth = MAX(self.owesLabel.frame.size.width,  self.paidLabel.frame.size.width);
    CGFloat xOrigin = AMOUNT_LABELS_MAX_X - maxAmountWidth - SMALL_GAP - maxLabelWidth;
    
    totalHeight = self.owesLabel.frame.size.height + self.paidLabel.frame.size.height;
    yOrigin = (self.contentView.frame.size.height - totalHeight) / 2.0;
    [self.owesLabel setOrigin:CGPointMake(xOrigin, yOrigin)];
    [self.paidLabel setOrigin:CGPointMake(xOrigin, CGRectGetMaxY(self.owesLabel.frame))];
    
    CGFloat maxX = xOrigin - SMALL_GAP;
    
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
