//
//  EVFormRow.m
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFormRow.h"

#define EV_FORM_ROW_MARGIN 10.0
#define EV_FORM_ROW_LABEL_FONT [EVFont blackFontOfSize:14]
@implementation EVFormRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat lineHeight = EV_FORM_ROW_LABEL_FONT.lineHeight;
        self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(EV_FORM_ROW_MARGIN,
                                                                    (frame.size.height - lineHeight) / 2.0,
                                                                    frame.size.width,
                                                                    lineHeight)];
        self.fieldLabel.font = EV_FORM_ROW_LABEL_FONT;
        self.fieldLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.fieldLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [self.fieldLabel sizeToFit];
    [self.fieldLabel setFrame:CGRectMake(EV_FORM_ROW_MARGIN,
                                         (self.frame.size.height - self.fieldLabel.frame.size.height) / 2.0,
                                         self.fieldLabel.frame.size.width,
                                         self.fieldLabel.frame.size.height)];
    
    if (self.contentView) {
        [self addSubview:self.contentView];
        
        // Put the content view to the right of the label.
        CGFloat x = CGRectGetMaxX(self.fieldLabel.frame) + EV_FORM_ROW_MARGIN;
        CGFloat maxWidth = (self.frame.size.width - EV_FORM_ROW_MARGIN - x);
        CGFloat width;
        
        // If the content view is less wide than the max width, stick it on the right.
        if (maxWidth > self.contentView.frame.size.width)
        {
            x = self.frame.size.width - EV_FORM_ROW_MARGIN - self.contentView.frame.size.width;
            width = self.contentView.frame.size.width;
        } else {
            width = maxWidth;
        }
        CGFloat y = (self.frame.size.height - self.contentView.frame.size.height) / 2.0;
        [self.contentView setFrame:CGRectMake(x, y, width, self.contentView.frame.size.height)];
    }
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
