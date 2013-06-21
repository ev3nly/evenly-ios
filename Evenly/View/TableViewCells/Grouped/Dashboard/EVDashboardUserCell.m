//
//  EVDashboardUserCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardUserCell.h"

#define LABELS_LEFT_MARGIN 64.0
#define AMOUNT_LABELS_MAX_X 275.0
#define SMALL_GAP 3.0

#define LARGE_FONT_SIZE 15
#define SMALL_FONT_SIZE 12

@interface EVDashboardUserCell ()

- (void)loadAvatarView;
- (void)loadNameLabel;
- (void)loadTierLabel;
- (void)loadOwesLabels;
- (void)loadPaidLabels;

@end

@implementation EVDashboardUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadAvatarView];
        [self loadNameLabel];
        [self loadTierLabel];
        [self loadOwesLabels];
        [self loadPaidLabels];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];

    }
    return self;
}

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:[self avatarFrame]];
    [self.contentView addSubview:self.avatarView];
}

- (CGRect)avatarFrame {
    return CGRectMake(8, 10, 44, 44);
}

- (void)loadNameLabel {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [EVFont blackFontOfSize:LARGE_FONT_SIZE];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.adjustsLetterSpacingToFitWidth = YES;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.nameLabel];
}

- (void)loadTierLabel {
    self.tierLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tierLabel.font = [EVFont defaultFontOfSize:SMALL_FONT_SIZE];
    self.tierLabel.textColor = [EVColor lightLabelColor];
    self.tierLabel.backgroundColor = [UIColor clearColor];
    self.tierLabel.adjustsLetterSpacingToFitWidth = YES;
    self.tierLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.tierLabel];
}

- (void)loadOwesLabels {
    self.owesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.owesLabel.text = @"Owes";
    self.owesLabel.font = [EVFont boldFontOfSize:SMALL_FONT_SIZE];
    self.owesLabel.textColor = [EVColor lightLabelColor];
    self.owesLabel.backgroundColor = [UIColor clearColor];
    [self.owesLabel sizeToFit];
    [self.contentView addSubview:self.owesLabel];

    self.owesAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.owesAmountLabel.font = [EVFont defaultFontOfSize:SMALL_FONT_SIZE];
    self.owesAmountLabel.backgroundColor = [UIColor clearColor];
    self.owesAmountLabel.textColor = [EVColor lightRedColor];
    [self.contentView addSubview:self.owesAmountLabel];
}

- (void)loadPaidLabels {
    self.paidLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.paidLabel.text = @"Paid";
    self.paidLabel.font = [EVFont boldFontOfSize:SMALL_FONT_SIZE];
    self.paidLabel.textColor = [EVColor lightLabelColor];
    self.paidLabel.backgroundColor = [UIColor clearColor];
    [self.paidLabel sizeToFit];
    [self.contentView addSubview:self.paidLabel];
    
    self.paidAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.paidAmountLabel.font = [EVFont defaultFontOfSize:SMALL_FONT_SIZE];
    self.paidAmountLabel.backgroundColor = [UIColor clearColor];
    self.paidAmountLabel.textColor = [EVColor lightGreenColor];
    [self.contentView addSubview:self.paidAmountLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
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
    
    CGFloat maxX = xOrigin;
    
    if (!EV_IS_EMPTY_STRING(self.tierLabel.text))
    {
        
    }
    else
    {
        [self.nameLabel setFrame:CGRectMake(LABELS_LEFT_MARGIN, 0, maxX - LABELS_LEFT_MARGIN, self.contentView.frame.size.height)];
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