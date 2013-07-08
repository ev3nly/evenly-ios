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
#define LEFT_RIGHT_BUFFER 10

#define FOR_LABEL_TEXT @"for"
#define FOR_LABEL_ADJUSTMENT 8

@interface EVExchangeWhatForView ()

@property (nonatomic, strong) UILabel *forLabel;

- (void)loadForLabel;
- (void)loadDescriptionField;

@end

@implementation EVExchangeWhatForView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadForLabel];
        [self loadDescriptionField];
    }
    return self;
}

- (void)loadForLabel
{
    UILabel *forLabel = [self configuredLabel];
    forLabel.text = FOR_LABEL_TEXT;
    forLabel.frame = [self forLabelFrame];
    self.forLabel = forLabel;
    [self addSubview:forLabel];
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

- (UILabel *)configuredLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = EV_RGB_COLOR(40, 40, 40);
    label.font = [EVFont darkExchangeFormFont];
    return label;
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


- (CGRect)forLabelFrame {
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [FOR_LABEL_TEXT sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) + FOR_LABEL_ADJUSTMENT : LINE_HEIGHT + (LINE_HEIGHT/2 - labelSize.height/2));
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      y,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)descriptionFieldFrame {
    float xOrigin = CGRectGetMaxX([self forLabelFrame]);
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) : LINE_HEIGHT + 2);
    return CGRectMake(xOrigin,
                      y,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - xOrigin,
                      self.bounds.size.height - [self forLabelFrame].origin.y);
}

- (void)setWhatForHeader:(EVExchangeWhatForHeader *)whatForHeader {
    [_whatForHeader removeFromSuperview];
    _whatForHeader = whatForHeader;
    [self addSubview:_whatForHeader];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.forLabel.frame = [self forLabelFrame];
    self.descriptionField.frame = [self descriptionFieldFrame];
}

@end
