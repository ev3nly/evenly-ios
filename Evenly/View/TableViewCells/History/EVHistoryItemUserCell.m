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
    return VALUE_LABEL_WIDTH;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(0, 0, AVATAR_VIEW_DIMENSION, AVATAR_VIEW_DIMENSION)];
        [self.contentView addSubview:self.avatarView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    float valueWidth = [self.valueLabel.text _safeSizeWithAttributes:@{NSFontAttributeName: self.valueLabel.font}].width;
    self.avatarView.frame = CGRectMake(CGRectGetMaxX(self.valueLabel.frame) - valueWidth - AVATAR_VIEW_DIMENSION - AVATAR_SPACING,
                                       (self.contentView.frame.size.height - AVATAR_VIEW_DIMENSION) / 2.0,
                                       AVATAR_VIEW_DIMENSION,
                                       AVATAR_VIEW_DIMENSION);
}
@end
