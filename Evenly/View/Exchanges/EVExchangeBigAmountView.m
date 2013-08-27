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
#define TOTAL_HEIGHT 160
#define AMOUNT_FIELD_HEIGHT 60
#define TITLE_CONTAINER_BUFFER 0

@implementation EVExchangeBigAmountView


+ (CGFloat)totalHeight {
    return TOTAL_HEIGHT;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.amountField.frame = [self amountFieldFrame];
}

- (void)loadBigAmountField {
    self.bigAmountContainer = [[EVGroupedTableViewCellBackground alloc] initWithFrame:CGRectMake(BIG_AMOUNT_CONTAINER_MARGIN,
                                                                                                 TITLE_CONTAINER_BUFFER,
                                                                                                 self.frame.size.width - 2*BIG_AMOUNT_CONTAINER_MARGIN,
                                                                                                 self.frame.size.height - BIG_AMOUNT_CONTAINER_MARGIN - MINIMUM_AMOUNT_LABEL_HEIGHT - TITLE_CONTAINER_BUFFER)];
    self.bigAmountContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bigAmountContainer.userInteractionEnabled = YES;
    self.bigAmountContainer.position = EVGroupedTableViewCellPositionSingle;
    [self addSubview:self.bigAmountContainer];
    
    self.amountField = [[EVTextField alloc] initWithFrame:[self amountFieldFrame]];
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
    self.minimumAmountLabel.textColor = [EVColor lightRedColor];
    self.minimumAmountLabel.text = @"$0.50 minimum.";
    self.minimumAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.minimumAmountLabel];
    [self.minimumAmountLabel setAlpha:0.0];
}

- (void)flashMinimumAmountLabel {
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                     animations:^{
                         self.minimumAmountLabel.alpha = 1.0;
                     } completion:^(BOOL finished) {
                        [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                                              delay:1.0f
                                            options:0
                                         animations:^{
                                             self.minimumAmountLabel.alpha = 0.0f;
                                         } completion:^(BOOL finished) {
                                             
                                         }];
                     }];
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

#pragma mark - Frames

- (CGRect)amountFieldFrame {
    return CGRectMake(BIG_AMOUNT_CONTAINER_MARGIN,
                      MAX(0, ((self.bigAmountContainer.frame.size.height - AMOUNT_FIELD_HEIGHT) / 2.0)),
                      self.bigAmountContainer.frame.size.width - 2*BIG_AMOUNT_CONTAINER_MARGIN,
                      AMOUNT_FIELD_HEIGHT);
}

@end
