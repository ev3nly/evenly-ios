//
//  EVPartialPaymentViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

#import "EVGroupRequestRecord.h"

@class EVPartialPaymentViewController;

@protocol EVPartialPaymentViewControllerDelegate <NSObject>

- (void)viewController:(EVPartialPaymentViewController *)viewController madePartialPayment:(EVPayment *)payment;

@end

@interface EVPartialPaymentViewController : EVViewController

@property (nonatomic, weak) id<EVPartialPaymentViewControllerDelegate> delegate;
@property (nonatomic, strong) EVGroupRequestRecord *record;

- (id)initWithRecord:(EVGroupRequestRecord *)record;

@end
