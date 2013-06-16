//
//  EVExchangeFormView.m
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeFormView.h"

#define LEFT_RIGHT_BUFFER 10
#define LABEL_FIELD_BUFFER 6
#define LINE_HEIGHT 40
#define MAX_AMOUNT_WIDTH 60

#define DESCRIPTION_PLACEHOLDER_TEXT @"Lunch, dinner, taxi, or anything else"

@interface EVExchangeFormView ()

- (void)loadPayLabel;
- (void)loadToField;
- (void)loadAmountField;
- (void)loadForLabel;
- (void)loadDescriptionField;
- (void)loadDivider;

- (UILabel *)configuredLabel;

- (CGRect)toFieldFrame;
- (CGRect)forLabelFrame;
- (CGRect)descriptionFieldFrame;
- (CGRect)dividerFrame;

@end

@implementation EVExchangeFormView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self loadPayLabel];
        [self loadToField];
        [self loadAmountField];
        [self loadForLabel];
        [self loadDescriptionField];
        [self loadDivider];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadPayLabel
{
    UILabel *payLabel = [self configuredLabel];
    payLabel.text = @"Pay";
    payLabel.frame = [self payLabelFrame];
    [self addSubview:payLabel];
}

- (void)loadToField
{
    self.toField = [self configuredTextField];
    self.toField.placeholder = @"Name, email, phone number";
    self.toField.frame = [self toFieldFrame];
    self.toField.returnKeyType = UIReturnKeyNext;
    self.toField.delegate = self;
    [self addSubview:self.toField];
    [self.toField becomeFirstResponder];
}

- (void)loadAmountField
{
    self.amountField = [self configuredTextField];
    self.amountField.placeholder = @"$0.00";
    self.amountField.frame = [self amountFieldFrame];
    self.amountField.textAlignment = NSTextAlignmentRight;
    self.amountField.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountField.delegate = self;
    self.amountField.returnKeyType = UIReturnKeyNext;
    [self addSubview:self.amountField];
    self.toField.next = self.amountField;
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
    self.descriptionField = [[UITextView alloc] initWithFrame:[self descriptionFieldFrame]];
    self.descriptionField.text = DESCRIPTION_PLACEHOLDER_TEXT;
    self.descriptionField.textColor = self.toField.textColor;
    self.descriptionField.font = self.toField.font;
    self.descriptionField.delegate = self;
    [self addSubview:self.descriptionField];
    self.amountField.next = self.descriptionField;
}

- (void)loadDivider
{
    UIView *divider = [[UIView alloc] initWithFrame:[self dividerFrame]];
    divider.backgroundColor = EV_RGB_COLOR(240, 240, 240);
    [self addSubview:divider];
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

#pragma mark - TextField/View Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountField && [textField.text rangeOfString:@"$"].location == NSNotFound) {
        textField.text = [[self amountPrefix] stringByAppendingString:textField.text];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:DESCRIPTION_PLACEHOLDER_TEXT])
        textView.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(EVTextField *)textField next]) {
        [[(EVTextField *)textField next] becomeFirstResponder];
        return NO;
    } 
    return YES;
}

#pragma mark - Frame Defines

- (CGRect)payLabelFrame {
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [@"Pay" sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      LINE_HEIGHT/2 - labelSize.height/2,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)toFieldFrame {
    float xOrigin = CGRectGetMaxX([self payLabelFrame]) + LABEL_FIELD_BUFFER;
    UILabel *label = [self configuredLabel];
    CGSize labelSize = [@"To" sizeWithFont:label.font constrainedToSize:CGSizeMake(self.bounds.size.width, LINE_HEIGHT) lineBreakMode:label.lineBreakMode];
    return CGRectMake(xOrigin,
                      LINE_HEIGHT/2 - labelSize.height/2,
                      self.bounds.size.width - LEFT_RIGHT_BUFFER - [self maxAmountWidth] - LABEL_FIELD_BUFFER - xOrigin,
                      labelSize.height);
}

- (CGRect)amountFieldFrame {
    return CGRectMake(self.bounds.size.width - LEFT_RIGHT_BUFFER - [self maxAmountWidth],
                      [self toFieldFrame].origin.y,
                      [self maxAmountWidth],
                      [self toFieldFrame].size.height);
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

- (CGRect)dividerFrame {
    return CGRectMake(0,
                      LINE_HEIGHT,
                      self.bounds.size.width,
                      1);
}

- (float)maxAmountWidth {
    return MAX_AMOUNT_WIDTH;
}

- (NSString *)amountPrefix {
    return @"$";
}

@end
