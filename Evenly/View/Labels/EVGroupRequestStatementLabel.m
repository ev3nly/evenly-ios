//
//  EVGroupRequestStatementLabel.m
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestStatementLabel.h"

#define FONT_SIZE 15
#define INDENT_WIDTH 10.0f
#define CATEGORY_LABEL_MAX_X 200.0

@implementation EVGroupRequestStatementLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = YES;
        
        self.categoryLabel = [self configuredLabel];
        [self addSubview:self.categoryLabel];
        self.dotsLabel = [self configuredLabel];
        self.dotsLabel.text = [self dots];
        [self addSubview:self.dotsLabel];
        self.amountLabel = [self configuredLabel];
        [self addSubview:self.amountLabel];
    }
    return self;
}

- (UILabel *)configuredLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [EVColor lightLabelColor];
    label.font = [EVFont defaultFontOfSize:FONT_SIZE];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

- (NSString *)dots {
    return @"..................................................."\
    "..........................................................."\
    "...........................................................";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.categoryLabel setFont:(self.bold ? [EVFont blackFontOfSize:FONT_SIZE] : [EVFont defaultFontOfSize:FONT_SIZE])];
    
    [self.categoryLabel sizeToFit];
    [self.amountLabel sizeToFit];
    
    CGRect frame = self.categoryLabel.frame;
    frame.origin.x = (self.indented ? INDENT_WIDTH : 0.0);
    frame.size.width = MIN(frame.size.width, CATEGORY_LABEL_MAX_X - frame.origin.x);
    frame.size.height = self.bounds.size.height;
    self.categoryLabel.frame = frame;
    
    frame = self.amountLabel.frame;
    frame.origin.x = self.frame.size.width - frame.size.width;
    frame.size.height = self.bounds.size.height;
    self.amountLabel.frame = frame;
    
    [self.dotsLabel setFrame:CGRectMake(CGRectGetMaxX(self.categoryLabel.frame),
                                        self.amountLabel.frame.origin.y,
                                        CGRectGetMinX(self.amountLabel.frame) - CGRectGetMaxX(self.categoryLabel.frame),
                                        self.amountLabel.frame.size.height)];
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
