//
//  EVRequestSingleAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestSingleAmountView.h"
#import "EVCurrencyTextFieldFormatter.h"


@interface EVRequestSingleAmountView ()

@property (nonatomic, strong) UIImageView *bigAmountContainer;
@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

@end

@implementation EVRequestSingleAmountView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBigAmountField];
    }
    return self;
}

- (void)loadBigAmountField {
    self.bigAmountView = [[EVExchangeBigAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width, [EVExchangeBigAmountView totalHeight])];
    [self addSubview:self.bigAmountView];
}

- (EVTextField *)amountField {
    return self.bigAmountView.amountField;
}

- (UILabel *)minimumAmountLabel {
    return self.bigAmountView.minimumAmountLabel;
}

- (BOOL)isFirstResponder {
    return self.amountField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.amountField becomeFirstResponder];
}



@end
