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

@interface EVExchangeWhatForView ()

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
    forLabel.text = @"For";
    forLabel.frame = [self forLabelFrame];
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

- (CGRect)forLabelFrame {
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [@"For" sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      LINE_HEIGHT + (LINE_HEIGHT/2 - labelSize.height/2),
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)descriptionFieldFrame {
    float xOrigin = CGRectGetMaxX([self forLabelFrame]);
    return CGRectMake(xOrigin,
                      LINE_HEIGHT + 2,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - xOrigin,
                      self.bounds.size.height - [self forLabelFrame].origin.y);
}


- (UILabel *)configuredLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = EV_RGB_COLOR(40, 40, 40);
    label.font = [EVFont darkExchangeFormFont];
    return label;
}

- (EVTextField *)configuredTextField {
    EVTextField *textField = [EVTextField new];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = EV_RGB_COLOR(180, 180, 180);
    textField.font = [EVFont lightExchangeFormFont];
    return textField;
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

@end
