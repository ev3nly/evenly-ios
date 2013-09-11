//
//  EVGroupRequestSingleAmountView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVExchangeHowMuchView.h"
#import "EVExchangeBigAmountView.h"
#import "EVGrayButton.h"

@interface EVGroupRequestSingleAmountView : EVExchangeHowMuchView

@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) EVGrayButton *addOptionButton;

@end
