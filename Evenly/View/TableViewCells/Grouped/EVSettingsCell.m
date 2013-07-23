//
//  EVSettingsCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/22/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSettingsCell.h"

#define EV_SETTINGS_ROW_MARGIN 12.0

@implementation EVSettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithImage:[EVImages lockIcon]];
        [self.contentView addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor newsfeedNounColor];
        self.label.font = [EVFont blackFontOfSize:15];
        self.label.numberOfLines = 1;
        [self.contentView addSubview:self.label];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[EVImages dashboardDisclosureArrow]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconView sizeToFit];
    
    CGFloat xOrigin = EV_SETTINGS_ROW_MARGIN;
    if (self.iconView.image) {
        [self.iconView setFrame:CGRectMake(EV_SETTINGS_ROW_MARGIN,
                                           (self.contentView.frame.size.height - self.iconView.image.size.height) / 2.0,
                                           self.iconView.image.size.width,
                                           self.iconView.image.size.height)];
        xOrigin = CGRectGetMaxX(self.iconView.frame) + EV_SETTINGS_ROW_MARGIN;
    }
    
    [self.label setFrame:CGRectMake(xOrigin,
                                    EV_SETTINGS_ROW_MARGIN,
                                    self.frame.size.width - EV_SETTINGS_ROW_MARGIN - xOrigin,
                                    (self.frame.size.height - 2*EV_SETTINGS_ROW_MARGIN))];
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
