//
//  EVRequestBigAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestBigAmountView.h"

#define BIG_AMOUNT_CONTAINER_MARGIN 10
#define BIG_AMOUNT_CONTAINER_HEIGHT 90
#define INFO_LABEL_HEIGHT 40

@implementation EVRequestBigAmountView


+ (CGFloat)totalHeight {
    return BIG_AMOUNT_CONTAINER_HEIGHT + 2*BIG_AMOUNT_CONTAINER_MARGIN + INFO_LABEL_HEIGHT;
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
    self.amountField.font = [EVFont blackFontOfSize:36];
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
                                                                        INFO_LABEL_HEIGHT)];
    self.minimumAmountLabel.font = [EVFont blackFontOfSize:16];
    self.minimumAmountLabel.backgroundColor = [UIColor clearColor];
    self.minimumAmountLabel.textColor = [EVColor lightLabelColor];
    self.minimumAmountLabel.text = @"$0.50 minimum";
    self.minimumAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.minimumAmountLabel];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
