//
//  EVExpansionArrowButton.m
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExpansionArrowButton.h"

@implementation EVExpansionArrowButton

+ (CGSize)size {
    return CGSizeMake(36, 36);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"arrowbutton"];
        [self setImage:image forState:UIControlStateNormal];
        self.expanded = NO;
        [self addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setExpanded:(BOOL)expanded {
    [self setExpanded:expanded animated:NO];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    _expanded = expanded;
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0) animations:^{
        if (_expanded)
            self.transform = CGAffineTransformMakeRotation(M_PI);
        else
            self.transform = CGAffineTransformIdentity;
    }];
}

- (void)tapped:(id)sender {
    if (sender == self) {
        [self setExpanded:!self.expanded animated:YES];
    }
}

@end
