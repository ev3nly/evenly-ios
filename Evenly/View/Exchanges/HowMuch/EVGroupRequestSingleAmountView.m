//
//  EVGroupRequestSingleAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestSingleAmountView.h"
#import "EVGroupRequestHowMuchView.h"

#define Y_SPACING 10.0
#define HINT_LABEL_HEIGHT 16.0


@implementation EVGroupRequestSingleAmountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadBigAmountView];
        [self loadHintLabel];
        [self loadAddOptionButton];

    }
    return self;
}

- (void)loadBigAmountView {
    self.bigAmountView = [[EVExchangeBigAmountView alloc] initWithFrame:[self bigAmountFrame]];
    [self addSubview:self.bigAmountView];
    
}


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

- (CGRect)bigAmountFrame {
    return CGRectMake(0,
                      0,
                      self.frame.size.width,
                      CGRectGetMinY([self hintLabelFrame]) - Y_SPACING / 2);
}

- (CGRect)hintLabelFrame {
    CGFloat yOrigin = [self addOptionButtonYOrigin] - HINT_LABEL_HEIGHT - 2.0;
    return CGRectMake(0,
                      yOrigin,
                      self.frame.size.width,
                      HINT_LABEL_HEIGHT);
}

- (CGFloat)addOptionButtonYOrigin {
    return self.frame.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - ADD_OPTION_BUTTON_HEIGHT - Y_SPACING;
}

- (CGRect)addOptionButtonFrame {
    return CGRectMake(20, [self addOptionButtonYOrigin], 280, ADD_OPTION_BUTTON_HEIGHT);
}


@end
