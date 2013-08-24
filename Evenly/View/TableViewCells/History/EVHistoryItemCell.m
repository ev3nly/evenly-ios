//
//  EVHistoryItemCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryItemCell.h"

#define FIELD_FONT [EVFont boldFontOfSize:15]
#define VALUE_FONT [EVFont defaultFontOfSize:15]

#define X_MARGIN 20.0
#define FIELD_LABEL_WIDTH 80.0
#define VALUE_LABEL_WIDTH 180.0
#define CELL_MINIMUM_HEIGHT 44.0

@implementation EVHistoryItemCell

+ (CGFloat)heightForValueText:(NSString *)valueText {
    CGSize size = [valueText sizeWithFont:[self valueLabelFont]
                        constrainedToSize:CGSizeMake([self valueLabelWidth], FLT_MAX)
                            lineBreakMode:NSLineBreakByWordWrapping];
    return MAX([self cellMinimumHeight], size.height);
}

+ (UIFont *)valueLabelFont {
    return [EVFont defaultFontOfSize:15];
}

+ (CGFloat)valueLabelWidth {
    return 190.0;
}

+ (CGFloat)cellMinimumHeight {
    return 44.0;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN,
                                                                    0,
                                                                    FIELD_LABEL_WIDTH,
                                                                    self.contentView.frame.size.height)];
        self.fieldLabel.font = FIELD_FONT;
        self.fieldLabel.backgroundColor = [UIColor clearColor];
        self.fieldLabel.textColor = [EVColor darkColor];
        self.fieldLabel.textAlignment = NSTextAlignmentLeft;
        self.fieldLabel.numberOfLines = 1;
        self.fieldLabel.adjustsFontSizeToFitWidth = YES;
        self.fieldLabel.minimumScaleFactor = 2.0;
        [self.contentView addSubview:self.fieldLabel];
        
        CGFloat xOrigin = CGRectGetMaxX(self.fieldLabel.frame);
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin + X_MARGIN,
                                                                    0,
                                                                    VALUE_LABEL_WIDTH,
                                                                    self.contentView.frame.size.height)];
        self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.valueLabel.font = VALUE_FONT;
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textColor = [EVColor darkColor];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.valueLabel.numberOfLines = 0;
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
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
