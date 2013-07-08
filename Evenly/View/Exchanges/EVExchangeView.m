//
//  EVRequestView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeView.h"

#define TITLE_LABEL_X_MARGIN 10
#define TITLE_LABEL_HEIGHT 25
#define TITLE_LABEL_FONT [EVFont blackFontOfSize:16]

@implementation EVExchangeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadTitleLabel];
    }
    return self;
}

- (void)loadTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X_MARGIN,
                                                                EV_REQUEST_VIEW_LABEL_FIELD_BUFFER,
                                                                self.frame.size.width - 2*TITLE_LABEL_X_MARGIN,
                                                                TITLE_LABEL_HEIGHT)];
    self.titleLabel.font = TITLE_LABEL_FONT;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.adjustsLetterSpacingToFitWidth = YES;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.6;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.titleLabel];
}

@end
