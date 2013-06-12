//
//  EVSettingsRow.m
//  Evenly
//
//  Created by Joseph Hankin on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSettingsRow.h"

#define EV_SETTINGS_ROW_MARGIN 12.0
#define EV_SETTINGS_ROW_LEFT_TEXT_MARGIN 45.0

@implementation EVSettingsRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithImage:[EVImages lockIcon]];
        [self addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor newsfeedNounColor];
        self.label.font = [EVFont blackFontOfSize:15];
        self.label.numberOfLines = 1;
        [self addSubview:self.label];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
        [self addSubview:self.accessoryView];
        
        self.adjustsImageWhenHighlighted = YES;
    }
    return self;
}

- (void)layoutSubviews {

    self.iconView.frame = CGRectMake(EV_SETTINGS_ROW_MARGIN,
                                     (self.frame.size.height - self.iconView.image.size.height) / 2.0,
                                     self.iconView.image.size.width,
                                     self.iconView.image.size.height);
    self.label.frame = CGRectMake(EV_SETTINGS_ROW_LEFT_TEXT_MARGIN,
                                  EV_SETTINGS_ROW_MARGIN,
                                  self.frame.size.width - EV_SETTINGS_ROW_LEFT_TEXT_MARGIN - EV_SETTINGS_ROW_MARGIN,
                                  self.frame.size.height - 2*EV_SETTINGS_ROW_MARGIN);
    self.accessoryView.frame = CGRectMake(self.frame.size.width - EV_SETTINGS_ROW_MARGIN - self.accessoryView.frame.size.width,
                                          (self.frame.size.height - self.accessoryView.frame.size.height) / 2.0,
                                          self.accessoryView.frame.size.width,
                                          self.accessoryView.frame.size.height);
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setBackgroundColor:(highlighted ? [EVColor newsfeedButtonHighlightColor] : [UIColor clearColor])];
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
