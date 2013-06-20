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
    UILabel *payLabel = [self configuredLabel];
    payLabel.text = @"Name";
    payLabel.frame = [self nameLabelFrame];
    [self addSubview:payLabel];
}

- (void)loadDivider
{
    UIView *divider = [[UIView alloc] initWithFrame:[self dividerFrame]];
    divider.backgroundColor = EV_RGB_COLOR(240, 240, 240);
    [self addSubview:divider];
}

- (void)loadNameField
{
    self.nameField = [self configuredTextField];
    self.nameField.placeholder = @"Rent, frat dues 2013, whatever";
    self.nameField.frame = [self toFieldFrame];
    self.nameField.returnKeyType = UIReturnKeyNext;
//    self.nameField.delegate = self;
    [self addSubview:self.nameField];
    [self.nameField becomeFirstResponder];
}

- (void)loadDescriptionLabel
{
    UILabel *forLabel = [self configuredLabel];
    forLabel.text = @"Description";
    forLabel.frame = [self descriptionLabelFrame];
    [self addSubview:forLabel];
}

- (void)loadDescriptionField
{
    EVPlaceholderTextView *field = [[EVPlaceholderTextView alloc] initWithFrame:[self descriptionFieldFrame]];
    field.placeholder = [EVStringUtility groupRequestDescriptionPlaceholder];
    self.descriptionField = field;
    self.descriptionField.textColor = [UIColor blackColor];
    self.descriptionField.font = [EVFont lightExchangeFormFont];
    [self addSubview:self.descriptionField];
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
    return textField;
}

#pragma mark - Frame Defines

- (CGRect)nameLabelFrame {
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [@"Name" sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      LINE_HEIGHT/2 - labelSize.height/2,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)toFieldFrame {
    float xOrigin = CGRectGetMaxX([self nameLabelFrame]) + LABEL_FIELD_BUFFER;
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [@"Name" sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    return CGRectMake(xOrigin,
                      LINE_HEIGHT/2 - labelSize.height/2,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - xOrigin,
                      labelSize.height);
}


- (CGRect)descriptionLabelFrame {
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [@"Description" sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      LINE_HEIGHT + (LINE_HEIGHT/2 - labelSize.height/2),
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)dividerFrame {
    return CGRectMake(0,
                      LINE_HEIGHT,
                      self.bounds.size.width,
                      1);
}

- (CGRect)descriptionFieldFrame {
    float xOrigin = CGRectGetMaxX([self descriptionLabelFrame]);
    return CGRectMake(xOrigin,
                      LINE_HEIGHT + 2,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - xOrigin,
                      self.bounds.size.height - [self descriptionLabelFrame].origin.y);
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
