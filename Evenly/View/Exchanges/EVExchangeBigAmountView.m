//
//  EVRequestBigAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeBigAmountView.h"

#define BIG_AMOUNT_CONTAINER_MARGIN 10
#define BIG_AMOUNT_CONTAINER_HEIGHT 100
#define BIG_AMOUNT_FONT [EVFont defaultFontOfSize:48]
#define MINIMUM_AMOUNT_FONT [EVFont defaultFontOfSize:16]
#define MINIMUM_AMOUNT_LABEL_HEIGHT 20

@implementation EVExchangeBigAmountView


+ (CGFloat)totalHeight {
    return BIG_AMOUNT_CONTAINER_HEIGHT + 2*BIG_AMOUNT_CONTAINER_MARGIN + MINIMUM_AMOUNT_LABEL_HEIGHT;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currencyFormatter = [[EVCurrencyTextFieldFormatter alloc] init];
        [self loadBigAmountField];
        [self loadMinimumAmountLabel];
    }
    return self;
}

- (void)loadBigAmountField {
    self.bigAmountContainer = [[UIImageView alloc] initWithFrame:CGRectMake(BIG_AMOUNT_CONTAINER_MARGIN,
                                                                            BIG_AMOUNT_CONTAINER_MARGIN,
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
    self.amountField.font = BIG_AMOUNT_FONT;
    self.amountField.textAlignment = NSTextAlignmentCenter;
    self.amountField.textColor = [UIColor blackColor];
    self.amountField.placeholder = @"$0.00";
    self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    self.amountField.delegate = self;
    [self.bigAmountContainer addSubview:self.amountField];
}

- (void)loadMinimumAmountLabel {
    self.minimumAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bigAmountContainer.frame),
                                                                        CGRectGetMaxY(self.bigAmountContainer.frame) + BIG_AMOUNT_CONTAINER_MARGIN,
                                                                        self.bigAmountContainer.frame.size.width,
                                                                        MINIMUM_AMOUNT_LABEL_HEIGHT)];
    self.minimumAmountLabel.font = MINIMUM_AMOUNT_FONT;
    self.minimumAmountLabel.backgroundColor = [UIColor clearColor];
    self.minimumAmountLabel.textColor = [EVColor lightLabelColor];
    self.minimumAmountLabel.text = @"$0.50 minimum.";
    self.minimumAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.minimumAmountLabel];
}

#pragma mark - First Responder

- (BOOL)becomeFirstResponder {
    return [self.amountField becomeFirstResponder];
}

- (BOOL)isFirstResponder {
    return [self.amountField isFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.amountField resignFirstResponder];
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
