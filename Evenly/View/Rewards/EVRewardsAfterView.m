//
//  EVRewardsAfterView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsAfterView.h"

#define HEADER_LABEL_HEIGHT 18.0
#define X_MARGIN 10.0
#define Y_MARGIN 20.0
#define OTHER_OPTIONS_LABEL_HEIGHT 40.0
#define Y_PADDING 5.0

@implementation EVRewardsAfterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, self.frame.size.width - 2*X_MARGIN, HEADER_LABEL_HEIGHT)];
        self.headerLabel.font = [EVFont blackFontOfSize:15];
        self.headerLabel.adjustsFontSizeToFitWidth = YES;
        self.headerLabel.adjustsLetterSpacingToFitWidth = YES;
        self.headerLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headerLabel];
        
        self.otherOptionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN,
                                                                           CGRectGetMaxY(self.headerLabel.frame) + Y_PADDING,
                                                                           self.frame.size.width - 2*X_MARGIN,
                                                                           OTHER_OPTIONS_LABEL_HEIGHT)];
        self.otherOptionsLabel.font = [EVFont defaultFontOfSize:15];
        self.otherOptionsLabel.numberOfLines = 0;
        self.otherOptionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.otherOptionsLabel.backgroundColor = [UIColor clearColor];
        self.otherOptionsLabel.textColor = [EVColor darkColor];
        [self addSubview:self.otherOptionsLabel];
        
        self.backgroundColor = [UIColor whiteColor];
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
