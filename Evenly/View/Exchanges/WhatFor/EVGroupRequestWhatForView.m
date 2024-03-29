//
//  EVRequestMultipleDetailsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestWhatForView.h"

#define LEFT_RIGHT_BUFFER 10
#define LABEL_FIELD_BUFFER 6
#define LINE_HEIGHT 40
#define TITLE_FIELD_HEIGHT 20
#define Y_BUFFER 10
#define X_BUFFER 8

#define TITLE_TEXT @"for"
#define DESCRIPTION_TEXT @""

@implementation EVGroupRequestWhatForView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadNameField];
        [self loadDivider];
        [self loadDescriptionField];
    }
    return self;
}

- (void)loadDivider
{
    UIView *divider = [[UIView alloc] initWithFrame:[self dividerFrame]];
    divider.backgroundColor = [EVColor newsfeedStripeColor];
    self.divider = divider;
    [self addSubview:divider];
}

- (void)loadNameField
{
    self.nameField = [self configuredTextField];
    self.nameField.placeholder = [EVStringUtility groupRequestTitlePlaceholder];
    self.nameField.frame = [self nameFieldFrame];
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.delegate = self;
    [self addSubview:self.nameField];
    [self.nameField becomeFirstResponder];
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
    
    self.nameField.next = self.descriptionField;
}

- (void)setWhatForHeader:(EVExchangeWhatForHeader *)whatForHeader {
    [_whatForHeader removeFromSuperview];
    _whatForHeader = whatForHeader;
    [self addSubview:_whatForHeader];
}

#pragma mark - Convenience Constructors

- (EVTextField *)configuredTextField {
    EVTextField *textField = [EVTextField new];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = EV_RGB_COLOR(40, 40, 40);;
    textField.font = [EVFont lightExchangeFormFont];
    textField.placeholderColor = EV_RGB_COLOR(0.7725, 0.7725, 0.7725);
    return textField;
}

#pragma mark - Frame Defines

- (CGRect)nameFieldFrame {
    CGFloat y = (self.whatForHeader ?
                 CGRectGetMaxY(self.whatForHeader.frame) + Y_BUFFER :
                 LINE_HEIGHT/2 - TITLE_FIELD_HEIGHT/2);
    return CGRectMake(X_BUFFER,
                      y,
                      self.bounds.size.width - X_BUFFER*2,
                      TITLE_FIELD_HEIGHT);
}

- (CGRect)dividerFrame {
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) + LINE_HEIGHT : LINE_HEIGHT);
    return CGRectMake(0,
                      y,
                      self.bounds.size.width,
                      [EVUtilities scaledDividerHeight]);
}

- (CGRect)descriptionFieldFrame {
    CGFloat y = (self.whatForHeader ? CGRectGetMaxY(self.whatForHeader.frame) + LINE_HEIGHT + 2: LINE_HEIGHT + 2);
    return CGRectMake(0,
                      y,
                      self.bounds.size.width,
                      self.bounds.size.height - y);
}

- (void)flashNoDescriptionMessage {
    [self flashMessage:@"Oops. Please add a brief description."
               inFrame:self.nameField.frame
          withDuration:1.0];
}

#pragma mark - Layout

- (void)layoutSubviews {
    self.nameField.frame = [self nameFieldFrame];
    self.divider.frame = [self dividerFrame];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(EVTextField *)textField next]) {
        [[(EVTextField *)textField next] becomeFirstResponder];
        return NO;
    }
    return YES;
}
@end
