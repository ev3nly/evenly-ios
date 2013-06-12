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
    UITextField *toField = [self configuredTextField];
    toField.placeholder = @"Name, email, phone number";
    toField.frame = [self toFieldFrame];
    [self addSubview:toField];
//    [toField becomeFirstResponder];
}

- (void)loadAmountField
{
    UITextField *amountField = [self configuredTextField];
    amountField.placeholder = @"$0.00";
    amountField.frame = [self amountFieldFrame];
    amountField.textAlignment = NSTextAlignmentRight;
    amountField.keyboardType = UIKeyboardTypeDecimalPad;
    amountField.delegate = self;
    [self addSubview:amountField];
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
    UITextField *defaultField = [self configuredTextField];
    UITextView *descriptionField = [[UITextView alloc] initWithFrame:[self descriptionFieldFrame]];
    descriptionField.text = DESCRIPTION_PLACEHOLDER_TEXT;
    descriptionField.textColor = defaultField.textColor;
    descriptionField.font = defaultField.font;
    descriptionField.delegate = self;
    [self addSubview:descriptionField];
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
    label.font = [EVFont blackFontOfSize:14];
    return label;
}

- (UITextField *)configuredTextField {
    UITextField *textField = [UITextField new];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = EV_RGB_COLOR(180, 180, 180);
    textField.font = [EVFont defaultFontOfSize:14];
    return textField;
}

#pragma mark - TextField/View Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text rangeOfString:@"$"].location == NSNotFound) {
        textField.text = [[self amountPrefix] stringByAppendingString:textField.text];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:DESCRIPTION_PLACEHOLDER_TEXT])
        textView.text = @"";
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
