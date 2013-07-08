//
//  EVRequestMultipleDetailsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestMultipleDetailsView.h"

#define LEFT_RIGHT_BUFFER 10
#define LABEL_FIELD_BUFFER 6
#define LINE_HEIGHT 40
#define Y_BUFFER 10
#define X_BUFFER 8

#define TITLE_TEXT @"Title"
#define DESCRIPTION_TEXT @"Details"

@implementation EVRequestMultipleDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadNameLabel];
        [self loadNameField];
        [self loadDivider];
        [self loadDescriptionLabel];
        [self loadDescriptionField];
    }
    return self;
}
- (void)loadNameLabel
{
    UILabel *nameLabel = [self configuredLabel];
    nameLabel.text = TITLE_TEXT;
    nameLabel.frame = [self nameLabelFrame];
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
}

- (void)loadDivider
{
    UIView *divider = [[UIView alloc] initWithFrame:[self dividerFrame]];
    divider.backgroundColor = EV_RGB_COLOR(240, 240, 240);
    self.divider = divider;
    [self addSubview:divider];
}

- (void)loadNameField
{
    self.nameField = [self configuredTextField];
    self.nameField.placeholder = [EVStringUtility groupRequestTitlePlaceholder];
    self.nameField.frame = [self nameFieldFrame];
    self.nameField.returnKeyType = UIReturnKeyNext;
    [self addSubview:self.nameField];
    [self.nameField becomeFirstResponder];
}

- (void)loadDescriptionLabel
{
    UILabel *descriptionLabel = [self configuredLabel];
    descriptionLabel.text = DESCRIPTION_TEXT;
    descriptionLabel.frame = [self descriptionLabelFrame];
    self.descriptionLabel = descriptionLabel;
    [self addSubview:descriptionLabel];
}

- (void)loadDescriptionField
{
    EVPlaceholderTextView *field = [[EVPlaceholderTextView alloc] initWithFrame:[self descriptionFieldFrame]];
    field.placeholder = [EVStringUtility groupRequestDescriptionPlaceholder];
    self.descriptionField = field;
    self.descriptionField.textColor = [UIColor blackColor];
    self.descriptionField.font = [EVFont lightExchangeFormFont];
    self.descriptionField.placeholderColor = EV_RGB_COLOR(0.7725, 0.7725, 0.7725);
    [self addSubview:self.descriptionField];
}

- (void)setWhatForHeader:(EVExchangeWhatForHeader *)whatForHeader {
    [_whatForHeader removeFromSuperview];
    _whatForHeader = whatForHeader;
    [self addSubview:_whatForHeader];
}

#pragma mark - Convenience Constructors

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
    textField.textColor = EV_RGB_COLOR(40, 40, 40);;
    textField.font = [EVFont lightExchangeFormFont];
    textField.placeholderColor = EV_RGB_COLOR(0.7725, 0.7725, 0.7725);
    return textField;
}

#pragma mark - Frame Defines

- (CGRect)nameLabelFrame {
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [TITLE_TEXT sizeWithFont:label.font
                           constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT)
                               lineBreakMode:label.lineBreakMode];
    CGFloat y = (self.whatForHeader ?
                 CGRectGetMaxY(self.whatForHeader.frame) + Y_BUFFER :
                 LINE_HEIGHT/2 - labelSize.height/2);
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      y,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)nameFieldFrame {
    float xOrigin = [self fieldXOrigin] + X_BUFFER;
    CGSize labelSize = [self nameLabelFrame].size;
    CGFloat y = (self.whatForHeader ?
                 CGRectGetMaxY(self.whatForHeader.frame) + Y_BUFFER :
                 LINE_HEIGHT/2 - labelSize.height/2);
    return CGRectMake(xOrigin,
                      y,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - xOrigin,
                      labelSize.height);
}

- (CGRect)dividerFrame {
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) + LINE_HEIGHT : LINE_HEIGHT);
    return CGRectMake(0,
                      y,
                      self.bounds.size.width,
                      1);
}


- (CGRect)descriptionLabelFrame {
    UILabel *label = [self configuredLabel];

    CGSize labelSize = [DESCRIPTION_TEXT sizeWithFont:label.font
                                    constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT)
                                        lineBreakMode:label.lineBreakMode];
    CGFloat y = (self.whatForHeader ?
                 CGRectGetMaxY(self.whatForHeader.frame) + LINE_HEIGHT + Y_BUFFER :
                 LINE_HEIGHT + (LINE_HEIGHT/2 - labelSize.height/2));
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      y,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)descriptionFieldFrame {
    float xOrigin = [self fieldXOrigin];
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) + LINE_HEIGHT + 2: LINE_HEIGHT + 2);
    return CGRectMake(xOrigin,
                      y,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - xOrigin,
                      self.bounds.size.height - [self descriptionLabelFrame].origin.y);
}

- (CGFloat)fieldXOrigin {
    return MAX(CGRectGetMaxX([self nameLabelFrame]), CGRectGetMaxX([self descriptionLabelFrame])) + LABEL_FIELD_BUFFER;
}

#pragma mark - Layout

- (void)layoutSubviews {
    self.nameLabel.frame = [self nameLabelFrame];
    self.nameField.frame = [self nameFieldFrame];
    self.divider.frame = [self dividerFrame];
    self.descriptionLabel.frame = [self descriptionLabelFrame];
    self.descriptionField.frame = [self descriptionFieldFrame];
}

#pragma mark - First Responder

- (BOOL)isFirstResponder {
    return self.nameField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.nameField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    BOOL didResign = [self.nameField resignFirstResponder];
    didResign |= [self.descriptionField resignFirstResponder];
    return didResign;
}

@end
