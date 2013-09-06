//
//  EVHistoryItemCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryItemCell.h"

#define FIELD_FONT [EVFont boldFontOfSize:15]
#define VALUE_FONT [EVFont romanFontOfSize:15]

#define X_MARGIN ([EVUtilities userHasIOS7] ? 20.0 : 10)
#define FIELD_LABEL_WIDTH 80.0
#define VALUE_LABEL_WIDTH ([EVUtilities userHasIOS7] ? 180.0 : 190)
#define CELL_MINIMUM_HEIGHT 44.0

#define VALUE_TOP_BOTTOM_BUFFER 6

@implementation EVHistoryItemCell

+ (CGFloat)heightForValueText:(NSString *)valueText {
    CGSize size = [valueText _safeBoundingRectWithSize:CGSizeMake([self valueLabelWidth], FLT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [self valueLabelFont]}
                                               context:NULL].size;
    float height = (int)MAX([self cellMinimumHeight], size.height + VALUE_TOP_BOTTOM_BUFFER*2);
    return height;
}

+ (UIFont *)valueLabelFont {
    return VALUE_FONT;
}

+ (CGFloat)valueLabelWidth {
    return VALUE_LABEL_WIDTH;
}

+ (CGFloat)cellMinimumHeight {
    return CELL_MINIMUM_HEIGHT;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.fieldLabel = [[UILabel alloc] initWithFrame:[self fieldLabelFrame]];
        self.fieldLabel.font = FIELD_FONT;
        self.fieldLabel.backgroundColor = [UIColor clearColor];
        self.fieldLabel.textColor = [EVColor darkLabelColor];
        self.fieldLabel.textAlignment = NSTextAlignmentLeft;
        self.fieldLabel.numberOfLines = 1;
        self.fieldLabel.adjustsFontSizeToFitWidth = YES;
        self.fieldLabel.minimumScaleFactor = 2.0;
        [self.contentView addSubview:self.fieldLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:[self valueLabelFrame]];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.fieldLabel.frame = [self fieldLabelFrame];
    self.valueLabel.frame = [self valueLabelFrame];
}

#pragma mark - Frames

- (CGRect)fieldLabelFrame {
    return CGRectMake(X_MARGIN,
                      0,
                      FIELD_LABEL_WIDTH,
                      self.contentView.frame.size.height);
}

- (CGRect)valueLabelFrame {
    return CGRectMake(CGRectGetMaxX(self.fieldLabel.frame) + X_MARGIN,
                      0,
                      VALUE_LABEL_WIDTH,
                      self.contentView.frame.size.height);
}

@end
