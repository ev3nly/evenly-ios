//
//  EVGroupRequestProgressView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestProgressView.h"

#define LABEL_X_MARGIN 5.0
#define LABEL_HEIGHT 20.0
#define PROGRESS_BAR_HEIGHT 22.0

@implementation EVGroupRequestProgressView

+ (CGFloat)height {
    return 50.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x,
                                           frame.origin.y,
                                           frame.size.width,
                                           [[self class] height])];
    if (self) {
        
        self.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.autoresizesSubviews = YES;
        
        self.leftLabel = [self configuredLabel];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftLabel];
        
        
        self.centerLabel = [self configuredLabel];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.textColor = [EVColor lightGreenColor];
        [self addSubview:self.centerLabel];
        
        self.rightLabel = [self configuredLabel];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightLabel];
        
        self.progressBar = [[EVProgressBar alloc] initWithFrame:CGRectMake(0,
                                                                           self.frame.size.height - PROGRESS_BAR_HEIGHT,
                                                                           self.frame.size.width,
                                                                           PROGRESS_BAR_HEIGHT)];
        self.progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.progressBar];
        
        self.enabled = YES;
    }
    return self;
}

- (UILabel *)configuredLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:[self labelFrame]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[EVFont blackFontOfSize:15]];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [label setText:@"$0.00"];
    return label;
}

- (CGRect)labelFrame {
    return CGRectMake(LABEL_X_MARGIN, 0, self.frame.size.width - 2*LABEL_X_MARGIN, LABEL_HEIGHT);
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self.progressBar setEnabled:enabled];
    if (_enabled) {
        self.leftLabel.textColor = [UIColor blackColor];
        self.centerLabel.alpha = 1.0;
        self.rightLabel.textColor = [UIColor blackColor];
    } else {
        self.leftLabel.textColor = [EVColor lightLabelColor];
        self.centerLabel.alpha = 0.0;
        self.rightLabel.textColor = [EVColor lightLabelColor];
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.leftLabel.frame = [self labelFrame];
//    self.centerLabel.frame = [self labelFrame];
//    self.rightLabel.frame = [self labelFrame];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
