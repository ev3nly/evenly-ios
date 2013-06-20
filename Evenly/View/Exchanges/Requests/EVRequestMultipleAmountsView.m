//
//  EVRequestMultipleAmountsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestMultipleAmountsView.h"

#define HEADER_LABEL_HEIGHT 48.0

@interface EVRequestMultipleAmountsView ()



- (void)loadHeaderLabel;
- (void)loadSegmentedControl;
- (void)loadSingleAmountView;
- (void)loadMultipleAmountsView;

@end

@implementation EVRequestMultipleAmountsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadHeaderLabel];
        [self loadSegmentedControl];
        [self loadSingleAmountView];
        [self loadMultipleAmountsView];
    }
    return self;
}

- (void)loadHeaderLabel {
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, HEADER_LABEL_HEIGHT)];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [EVFont blackFontOfSize:16];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.text = @"Each person owes me...";
    [self addSubview:self.headerLabel];
}

- (void)loadSegmentedControl {
    self.segmentedControl = [[EVSegmentedControl alloc] initWithItems:@[@"The Same Amount", @"Different Amounts"]];
    [self.segmentedControl setFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame), self.frame.size.width, 45)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentedControl];
}

- (void)loadSingleAmountView {
    self.singleAmountView = [[EVRequestBigAmountView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.segmentedControl.frame),
                                                                     self.frame.size.width,
                                                                     EV_DEFAULT_KEYBOARD_HEIGHT - CGRectGetMaxY(self.segmentedControl.frame))];
    [self addSubview:self.singleAmountView];    
}

- (void)loadMultipleAmountsView {
    
}

#pragma mark - Controls

- (void)segmentedControlChanged:(EVSegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self addSubview:self.singleAmountView];
        [self.multipleAmountsView removeFromSuperview];
    } else {
        [self addSubview:self.multipleAmountsView];
        [self.singleAmountView removeFromSuperview];
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
