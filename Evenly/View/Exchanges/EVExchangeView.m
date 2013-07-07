//
//  EVRequestView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeView.h"

#define TITLE_LABEL_HEIGHT 25


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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                EV_REQUEST_VIEW_LABEL_FIELD_BUFFER,
                                                                self.frame.size.width,
                                                                TITLE_LABEL_HEIGHT)];
    self.titleLabel.font = [EVFont blackFontOfSize:18];
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
