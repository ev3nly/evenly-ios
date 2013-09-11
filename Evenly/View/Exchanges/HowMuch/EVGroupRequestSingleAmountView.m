//
//  EVGroupRequestSingleAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestSingleAmountView.h"
#import "EVGroupRequestHowMuchView.h"

#define ADD_OPTION_BUTTON_BOTTOM_MARGIN ([EVUtilities deviceHasTallScreen] ? 20 : 10)
#define ADD_OPTION_BUTTON_SIDE_MARGIN 20.0
#define HINT_LABEL_Y_OFFSET -30

@implementation EVGroupRequestSingleAmountView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadHintLabel];
        [self loadAddOptionButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bigAmountView.backgroundColor = [UIColor clearColor];
    self.bigAmountView.frame = [self bigAmountViewFrame];
    self.hintLabel.frame = [self hintLabelFrame];
    self.addOptionButton.frame = [self addOptionButtonFrame];
}

#pragma mark - View Loading

- (void)loadHintLabel {
    self.hintLabel = [[UILabel alloc] initWithFrame:[self hintLabelFrame]];
    self.hintLabel.backgroundColor = [UIColor clearColor];
    self.hintLabel.font = [EVFont defaultFontOfSize:15];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.textColor = [EVColor lightLabelColor];
    self.hintLabel.text = @"Do your friends owe different amounts?";
    [self addSubview:self.hintLabel];
}

- (void)loadAddOptionButton {
    self.addOptionButton = [[EVGrayButton alloc] initWithFrame:[self addOptionButtonFrame]];
    [self.addOptionButton setTitle:[EVStringUtility addAdditionalOptionButtonTitle] forState:UIControlStateNormal];
    [self addSubview:self.addOptionButton];
}
#pragma mark - Frames

- (CGRect)bigAmountViewFrame {
    float bigAmountHeight = [EVUtilities deviceHasTallScreen] ? [EVExchangeBigAmountView totalHeight] : 100;
    return CGRectMake(0,
                      0,
                      self.frame.size.width,
                      bigAmountHeight);
}

- (CGRect)hintLabelFrame {
    float yOrigin = CGRectGetMaxY(self.bigAmountView.frame) + HINT_LABEL_Y_OFFSET;
    return CGRectMake(0,
                      yOrigin,
                      self.frame.size.width,
                      [self addOptionButtonYOrigin] - yOrigin);
}

- (CGFloat)addOptionButtonYOrigin {
    return self.frame.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - ADD_OPTION_BUTTON_HEIGHT - ADD_OPTION_BUTTON_BOTTOM_MARGIN;
}

- (CGRect)addOptionButtonFrame {
    return CGRectMake(ADD_OPTION_BUTTON_SIDE_MARGIN,
                      [self addOptionButtonYOrigin],
                      self.bounds.size.width - ADD_OPTION_BUTTON_SIDE_MARGIN*2,
                      ADD_OPTION_BUTTON_HEIGHT);
}


@end
