//
//  EVHistoryPaymentViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryAbstractViewController.h"
#import "EVPayment.h"

typedef enum {
    EVHistoryPaymentRowFrom,
    EVHistoryPaymentRowTo,
    EVHistoryPaymentRowAmount,
    EVHistoryPaymentRowFor,
    EVHistoryPaymentRowDate,
    EVHistoryPaymentRowCOUNT
} EVHistoryPaymentRow;

@interface EVHistoryPaymentViewController : EVHistoryAbstractViewController

- (id)initWithPayment:(EVPayment *)payment;

@end
