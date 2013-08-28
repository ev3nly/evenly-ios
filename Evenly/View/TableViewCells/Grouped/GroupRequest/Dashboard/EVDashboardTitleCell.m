//
//  EVDashboardTitleCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardTitleCell.h"

#define DASHBOARD_MEMO_FONT [EVFont defaultFontOfSize:15]

#define DASHBOARD_LABEL_MAX_WIDTH 240.0
#define DASHBOARD_LABEL_TOP_BOTTOM_MARGIN 10.0
#define DASHBOARD_LABEL_SEPARATION 0.0

@implementation EVDashboardTitleCell

+ (CGFloat)heightWithMemo:(NSString *)memo {
    if (EV_IS_EMPTY_STRING(memo))
        return 0.0;
    CGSize memoSize = [self sizeForMemo:memo];
    return DASHBOARD_LABEL_TOP_BOTTOM_MARGIN + memoSize.height + DASHBOARD_LABEL_TOP_BOTTOM_MARGIN;
}

+ (CGSize)sizeForMemo:(NSString *)memo {
    return [memo boundingRectWithSize:CGSizeMake(DASHBOARD_LABEL_MAX_WIDTH, FLT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: DASHBOARD_MEMO_FONT}
                              context:NULL].size;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.position = EVGroupedTableViewCellPositionTop;

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
    
    CGSize memoSize = [[self class] sizeForMemo:self.memoLabel.text];
    self.memoLabel.frame = CGRectIntegral(CGRectMake((self.contentView.frame.size.width - memoSize.width) / 2.0,
                                                     DASHBOARD_LABEL_TOP_BOTTOM_MARGIN,
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
