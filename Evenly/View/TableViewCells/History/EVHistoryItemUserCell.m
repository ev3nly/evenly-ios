//
//  EVHistoryItemUserCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryItemUserCell.h"
#import "EVAvatarView.h"

#define VALUE_FONT [EVFont defaultFontOfSize:15]
#define AVATAR_VIEW_DIMENSION 30.0
#define AVATAR_SPACING 8.0
#define VALUE_LABEL_WIDTH 190.0 - AVATAR_VIEW_DIMENSION - AVATAR_SPACING
#define CELL_MINIMUM_HEIGHT 44.0

@implementation EVHistoryItemUserCell

+ (CGFloat)valueLabelWidth {
    return 190.0 - AVATAR_VIEW_DIMENSION - AVATAR_SPACING;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.avatarView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxX = CGRectGetMaxX(self.valueLabel.frame);
    CGFloat height = self.valueLabel.frame.size.height;
//    [self.valueLabel setFrame:CGRectMake(maxX - self.valueLabel.frame.size.width,
//                                         (self.contentView.frame.size.height - height) / 2.0,
//                                         self.valueLabel.frame.size.width,
//                                         height)];
    
    CGSize valueLabelSize = [self.valueLabel.text sizeWithFont:self.valueLabel.font
                                             constrainedToSize:CGSizeMake(self.valueLabel.frame.size.width, FLT_MAX)
                                                 lineBreakMode:self.valueLabel.lineBreakMode];
    
    self.avatarView.frame = CGRectMake(CGRectGetMaxX(self.valueLabel.frame) - valueLabelSize.width - AVATAR_VIEW_DIMENSION - AVATAR_SPACING,
                                       (self.contentView.frame.size.height - AVATAR_VIEW_DIMENSION) / 2.0,
                                       AVATAR_VIEW_DIMENSION,
                                       AVATAR_VIEW_DIMENSION);
}
@end
