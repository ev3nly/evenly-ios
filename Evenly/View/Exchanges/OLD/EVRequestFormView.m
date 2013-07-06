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
    self.amountField = [self configuredTextField];
    self.amountField.placeholder = @"owes me $0.00";
    self.amountField.frame = [self amountFieldFrame];
    self.amountField.textAlignment = NSTextAlignmentRight;
    self.amountField.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountField.delegate = self;
    [self addSubview:self.amountField];
    self.toField.next = self.amountField;
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
