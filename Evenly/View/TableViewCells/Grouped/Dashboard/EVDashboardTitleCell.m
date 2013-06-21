//
//  EVDashboardTitleCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardTitleCell.h"

#define DASHBOARD_TITLE_FONT [EVFont blackFontOfSize:20]
#define DASHBOARD_MEMO_FONT [EVFont defaultFontOfSize:15]

#define DASHBOARD_LABEL_MAX_WIDTH 240.0
#define DASHBOARD_LABEL_TOP_BOTTOM_MARGIN 20.0
#define DASHBOARD_LABEL_SEPARATION 0.0

@implementation EVDashboardTitleCell

+ (CGFloat)heightWithTitle:(NSString *)title memo:(NSString *)memo {
    CGSize titleSize = [self sizeForTitle:title];
    CGSize memoSize = [self sizeForMemo:memo];
    return DASHBOARD_LABEL_TOP_BOTTOM_MARGIN + titleSize.height + DASHBOARD_LABEL_SEPARATION + memoSize.height + DASHBOARD_LABEL_TOP_BOTTOM_MARGIN;
}

+ (CGSize)sizeForTitle:(NSString *)title {
    return [title sizeWithFont:DASHBOARD_TITLE_FONT
             constrainedToSize:CGSizeMake(DASHBOARD_LABEL_MAX_WIDTH, FLT_MAX)
                 lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)sizeForMemo:(NSString *)memo {
    return [memo sizeWithFont:DASHBOARD_MEMO_FONT
            constrainedToSize:CGSizeMake(DASHBOARD_LABEL_MAX_WIDTH, FLT_MAX)
                lineBreakMode:NSLineBreakByWordWrapping];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.position = EVGroupedTableViewCellPositionTop;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = DASHBOARD_TITLE_FONT;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.titleLabel];
        
        self.memoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.memoLabel.font = DASHBOARD_MEMO_FONT;
        self.memoLabel.backgroundColor = [UIColor clearColor];
        self.memoLabel.textColor = [EVColor lightLabelColor];
        self.memoLabel.textAlignment = NSTextAlignmentCenter;
        self.memoLabel.numberOfLines = 0;
        self.memoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.memoLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [[self class] sizeForTitle:self.titleLabel.text];
    self.titleLabel.frame = CGRectIntegral(CGRectMake((self.contentView.frame.size.width - titleSize.width) / 2.0,
                                                      DASHBOARD_LABEL_TOP_BOTTOM_MARGIN,
                                                      titleSize.width,
                                                      titleSize.height));
    
    CGSize memoSize = [[self class] sizeForMemo:self.memoLabel.text];
    self.memoLabel.frame = CGRectIntegral(CGRectMake((self.contentView.frame.size.width - memoSize.width) / 2.0,
                                                     CGRectGetMaxY(self.titleLabel.frame) + DASHBOARD_LABEL_SEPARATION,
                                                     memoSize.width,
                                                     memoSize.height));    
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
