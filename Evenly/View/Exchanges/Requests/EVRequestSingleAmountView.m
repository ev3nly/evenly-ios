//
//  EVRequestSingleAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestSingleAmountView.h"
#import "EVCurrencyTextFieldFormatter.h"

#define BIG_AMOUNT_CONTAINER_MARGIN 10
#define BIG_AMOUNT_CONTAINER_HEIGHT 90

@interface EVRequestSingleAmountView ()

@property (nonatomic, strong) UIImageView *bigAmountContainer;
@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

@end

@implementation EVRequestSingleAmountView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currencyFormatter = [[EVCurrencyTextFieldFormatter alloc] init];
        [self loadBigAmountField];
    }
    return self;
}

- (void)setDebtorName:(NSString *)debtorName {
    _debtorName = debtorName;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ owes me", debtorName];
}

- (void)loadBigAmountField {
    self.bigAmountContainer = [[UIImageView alloc] initWithFrame:CGRectMake(BIG_AMOUNT_CONTAINER_MARGIN,
                                                                            CGRectGetMaxY(self.titleLabel.frame) + BIG_AMOUNT_CONTAINER_MARGIN,
                                                                            self.frame.size.width - 2*BIG_AMOUNT_CONTAINER_MARGIN,
                                                                            BIG_AMOUNT_CONTAINER_HEIGHT)];
    self.bigAmountContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.bigAmountContainer.image = [EVImages resizableTombstoneBackground];
    self.bigAmountContainer.userInteractionEnabled = YES;
    [self addSubview:self.bigAmountContainer];
    
    CGRect amountFieldFrame = CGRectMake(BIG_AMOUNT_CONTAINER_MARGIN,
                                         2*BIG_AMOUNT_CONTAINER_MARGIN,
                                         self.bigAmountContainer.frame.size.width - 2*BIG_AMOUNT_CONTAINER_MARGIN,
                                         self.bigAmountContainer.frame.size.height - 4*BIG_AMOUNT_CONTAINER_MARGIN);
    self.amountField = [[EVTextField alloc] initWithFrame:amountFieldFrame];
    self.amountField.font = [EVFont blackFontOfSize:36];
    self.amountField.textAlignment = NSTextAlignmentCenter;
    self.amountField.textColor = [UIColor blackColor];
    self.amountField.placeholder = @"$0.00";
    self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    self.amountField.delegate = self;
    [self.bigAmountContainer addSubview:self.amountField];
}

- (BOOL)isFirstResponder {
    return self.amountField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.amountField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountField) {
        [self.currencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
        [self.amountField setText:self.currencyFormatter.formattedString];
        [self.amountField sendActionsForControlEvents:UIControlEventEditingChanged]; // for rac_textSignal
        return NO;
    }
    return YES;
}

@end
