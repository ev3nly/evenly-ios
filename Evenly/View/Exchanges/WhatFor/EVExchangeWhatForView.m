//
//  EVRequestDetailsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeWhatForView.h"
#import "EVPlaceholderTextView.h"

#define LINE_HEIGHT 40
#define LEFT_RIGHT_BUFFER 5

#define FOR_LABEL_TEXT @"for"
#define FOR_LABEL_ADJUSTMENT 8

@interface EVExchangeWhatForView ()

@property (nonatomic, strong) UILabel *forLabel;

- (void)loadDescriptionField;

@end

@implementation EVExchangeWhatForView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDescriptionField];
    }
    return self;
}

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

- (BOOL)isFirstResponder {
    return self.descriptionField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.descriptionField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.descriptionField resignFirstResponder];
}

#pragma mark - Layout

- (CGRect)descriptionFieldFrame {
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) : LINE_HEIGHT + 2);
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      y,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER*2,
                      self.bounds.size.height);
}

- (void)setWhatForHeader:(EVExchangeWhatForHeader *)whatForHeader {
    [_whatForHeader removeFromSuperview];
    _whatForHeader = whatForHeader;
    [self addSubview:_whatForHeader];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.descriptionField.frame = [self descriptionFieldFrame];
}

- (void)flashNoDescriptionMessage {
    CGRect frame = [self descriptionFieldFrame];
    frame.size.width = CGRectGetMaxX([self descriptionFieldFrame]);
    frame.size.height = 32.0;
    [self flashMessage:@"Oops. Please add a brief description."
               inFrame:frame
          withDuration:1.0];
}

@end
