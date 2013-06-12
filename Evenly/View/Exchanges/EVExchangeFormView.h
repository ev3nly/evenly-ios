//
//  EVExchangeFormView.h
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVExchangeFormView : UIView <UITextFieldDelegate, UITextViewDelegate>

- (UITextField *)configuredTextField;
- (CGRect)payLabelFrame;
- (CGRect)amountFieldFrame;
- (float)maxAmountWidth;
- (NSString *)amountPrefix;

@end
