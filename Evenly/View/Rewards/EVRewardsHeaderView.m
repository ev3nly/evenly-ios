//
//  EVRewardsHeaderView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsHeaderView.h"

#define X_MARGIN 20
#define FONT_SIZE 17

@implementation EVRewardsHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_smile"]];
        [self.logoView setOrigin:CGPointMake(X_MARGIN, (self.frame.size.height - self.logoView.frame.size.height) / 2.0)];
        [self addSubview:self.logoView];
        self.logoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIView *instructionView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoView.frame) + X_MARGIN,
                                                                           self.logoView.frame.origin.y,
                                                                           self.frame.size.width - 2*X_MARGIN - CGRectGetMaxX(self.logoView.frame),
                                                                           self.logoView.frame.size.height)];
        
        self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, instructionView.frame.size.width, instructionView.frame.size.height / 2.0)];
        self.instructionLabel.text = @"Slide to reveal your reward.";
        self.instructionLabel.font = [EVFont defaultFontOfSize:FONT_SIZE];
        self.instructionLabel.backgroundColor = [UIColor clearColor];
        self.instructionLabel.textColor = [EVColor darkColor];
        self.instructionLabel.adjustsLetterSpacingToFitWidth = YES;
        [instructionView addSubview:self.instructionLabel];
        
        self.pickWiselyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                         instructionView.frame.size.height / 2.0,
                                                                         instructionView.frame.size.width,
                                                                         instructionView.frame.size.height / 2.0)];
        self.pickWiselyLabel.text = @"Pick wisely!";
        self.pickWiselyLabel.font = [EVFont blackFontOfSize:FONT_SIZE];
        self.pickWiselyLabel.backgroundColor = [UIColor clearColor];
        self.pickWiselyLabel.textColor = [EVColor darkColor];
        [instructionView addSubview:self.pickWiselyLabel];
        instructionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:instructionView];
        
        // Initialization code
    }
    return self;
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
