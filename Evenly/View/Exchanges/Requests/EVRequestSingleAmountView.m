//
//  EVRequestSingleAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestSingleAmountView.h"

@implementation EVRequestSingleAmountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
    }
    return self;
}

- (void)setDebtorName:(NSString *)debtorName {
    _debtorName = debtorName;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ owes me", debtorName];
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
