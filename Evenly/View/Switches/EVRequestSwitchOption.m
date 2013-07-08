//
//  EVRequestSwitchOption.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestSwitchOption.h"

#define REQUEST_SWITCH_WELL_INSET 2
#define REQUEST_SWITCH_SEPARATOR_WIDTH 5.0

@implementation EVRequestSwitchOption

+ (instancetype)friendOption {
    EVRequestSwitchOption *option = [[self alloc] initWithFrame:CGRectMake(REQUEST_SWITCH_WELL_INSET, REQUEST_SWITCH_WELL_INSET, 149, 31)];
    option.iconView.image = [UIImage imageNamed:@"Request-Single-Light"];
    option.iconView.highlightedImage = [UIImage imageNamed:@"Request-Single-Dark"];
    option.label.text = @"Friend";
    [option setNeedsLayout];
    return option;
}

+ (instancetype)groupOption {
    EVRequestSwitchOption *option = [[self alloc] initWithFrame:CGRectMake(149 + REQUEST_SWITCH_WELL_INSET, REQUEST_SWITCH_WELL_INSET, 149, 31)];
    option.iconView.image = [UIImage imageNamed:@"Request-Group-Light"];
    option.iconView.highlightedImage = [UIImage imageNamed:@"Request-Group-Dark"];
    option.label.text = @"Group";
    [option setNeedsLayout];
    return option;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor highlightedTextColor];
        self.label.highlightedTextColor = [UIColor blackColor];
        self.label.font = [EVFont blackFontOfSize:15];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    self.iconView.highlighted = highlighted;
    self.label.highlighted = highlighted;
}

- (void)layoutSubviews {
    [self.label sizeToFit];
    [self.iconView sizeToFit];
    
    CGFloat totalWidth = self.label.frame.size.width + self.iconView.frame.size.width + REQUEST_SWITCH_SEPARATOR_WIDTH;
    CGPoint origin = CGPointZero;
    origin.x = (int)((self.frame.size.width - totalWidth) / 2.0);
    origin.y = (int)((self.frame.size.height - self.iconView.frame.size.height) / 2.0);
    [self.iconView setOrigin:origin];
    
    origin.x = CGRectGetMaxX(self.iconView.frame) + REQUEST_SWITCH_SEPARATOR_WIDTH;
    origin.y = (int)((self.frame.size.height - self.label.frame.size.height) / 2.0);
    [self.label setOrigin:origin];
}

@end
