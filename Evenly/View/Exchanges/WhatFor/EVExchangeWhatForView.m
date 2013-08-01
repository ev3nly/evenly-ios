//
//  EVRequestDetailsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeWhatForView.h"
#import "EVPlaceholderTextView.h"
#import "EVChooseTipCell.h"

#define LINE_HEIGHT 40
#define LEFT_RIGHT_BUFFER 5

#define TIP_LEFT_BUFFER 10
#define TIP_TOP_BUFFER ([EVUtilities deviceHasTallScreen] ? 10 : 2)

#define FOR_LABEL_TEXT @"for"
#define FOR_LABEL_ADJUSTMENT 8

@interface EVExchangeWhatForView ()

@property (nonatomic, strong) UILabel *forLabel;
@property (nonatomic, strong) EVChooseTipCell *tipView;

- (void)loadDescriptionField;

@end

@implementation EVExchangeWhatForView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadDescriptionField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tipView.frame = [self tipViewFrame];
    self.descriptionField.frame = [self descriptionFieldFrame];
}

#pragma mark - View Loading

- (void)loadDescriptionField
{
    EVPlaceholderTextView *field = [[EVPlaceholderTextView alloc] initWithFrame:[self descriptionFieldFrame]];
    field.placeholder = [EVStringUtility requestDescriptionPlaceholder];
    self.descriptionField = field;
    self.descriptionField.textColor = [UIColor blackColor];
    self.descriptionField.font = [EVFont lightExchangeFormFont];
    self.descriptionField.delegate = self;
    [self addSubview:self.descriptionField];
}

- (void)loadTipView {
    self.tipView = [EVChooseTipCell new];
    [self addSubview:self.tipView];
}

#pragma mark - Setters

- (void)setWhatForHeader:(EVExchangeWhatForHeader *)whatForHeader {
    [_whatForHeader removeFromSuperview];
    _whatForHeader = whatForHeader;
    [self addSubview:_whatForHeader];
}

- (void)setTip:(EVTip *)tip {
    _tip = tip;
    
    [self loadTipView];
    self.tipView.tip = tip;
    ((EVPlaceholderTextView *)self.descriptionField).placeholder = [EVStringUtility tipDescriptionPlaceholder];
}

#pragma mark - Utility

- (void)flashNoDescriptionMessage {
    CGRect frame = [self descriptionFieldFrame];
    frame.size.width = CGRectGetMaxX([self descriptionFieldFrame]);
    frame.size.height = 32.0;
    [self flashMessage:@"Oops. Please add a brief description."
               inFrame:frame
          withDuration:1.0];
}

#pragma mark - Responder Forwarding


- (BOOL)isFirstResponder {
    return self.descriptionField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.descriptionField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.descriptionField resignFirstResponder];
}

#pragma mark - Frames

- (CGRect)tipViewFrame {
    CGSize tipCellSize = [EVChooseTipCell sizeForTipCell];
    return CGRectMake(TIP_LEFT_BUFFER,
                      CGRectGetMaxY(self.whatForHeader.frame) + TIP_TOP_BUFFER,
                      tipCellSize.width,
                      tipCellSize.height);
}

- (CGRect)descriptionFieldFrame {
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) : LINE_HEIGHT + 2);
    return CGRectMake(CGRectGetMaxX(self.tipView.frame) + LEFT_RIGHT_BUFFER,
                      y,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER*2 - CGRectGetMaxX(self.tipView.frame),
                      self.bounds.size.height);
}

@end
