//
//  EVRequestFormView.m
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestFormView.h"

@implementation EVRequestFormView

#pragma mark - View Overrides

- (void)loadAmountField
{
    UITextField *amountField = [self configuredTextField];
    amountField.placeholder = @"owes me $0.00";
    amountField.frame = [self amountFieldFrame];
    amountField.textAlignment = NSTextAlignmentRight;
    amountField.keyboardType = UIKeyboardTypeDecimalPad;
    amountField.delegate = self;
    [self addSubview:amountField];
}

- (CGRect)payLabelFrame {
    return CGRectZero;
}

- (float)maxAmountWidth {
    return 114;
}

- (NSString *)amountPrefix {
    return @"owes me $";
}

@end
