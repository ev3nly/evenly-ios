//
//  EVCheckingSavingsCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCheckingSavingsCell.h"

@implementation EVCheckingSavingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.checkingButton = [[EVCheckmarkButton alloc] initWithText:@"Checking"];
        self.checkingButton.frame = CGRectMake(0,
                                               0,
                                               self.contentView.frame.size.width / 2.0,
                                               self.contentView.frame.size.height);
        self.checkingButton.xMargin = 17;
        self.checkingButton.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self.contentView addSubview:self.checkingButton];
        self.checkingButton.checked = YES;
        self.checkingButton.label.font = [EVFont blackFontOfSize:15];
        
        [self.checkingButton addTarget:self action:@selector(checkingButtonPress:) forControlEvents:UIControlEventTouchUpInside];

        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 2.0,
                                                                  0,
                                                                  [EVUtilities scaledDividerHeight],
                                                                  self.contentView.frame.size.height)];
        stripe.backgroundColor = [EVColor newsfeedStripeColor];
        stripe.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:stripe];
        
        self.savingsButton = [[EVCheckmarkButton alloc] initWithText:@"Savings"];
        self.savingsButton.frame = CGRectMake(self.contentView.frame.size.width / 2.0,
                                              0,
                                              self.contentView.frame.size.width / 2.0,
                                              self.contentView.frame.size.height);
        self.savingsButton.xMargin = 15;
        self.savingsButton.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self.contentView addSubview:self.savingsButton];
        [self.savingsButton addTarget:self action:@selector(savingsButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)checkingButtonPress:(id)sender {
    [self.savingsButton fadeBetweenChecks];
}

- (void)savingsButtonPress:(id)sender {
    [self.checkingButton fadeBetweenChecks];
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
