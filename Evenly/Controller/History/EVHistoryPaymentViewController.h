//
//  EVHistoryPaymentViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryItemViewController.h"
#import "EVPayment.h"

typedef enum {
    EVHistoryPaymentRowFrom,
    EVHistoryPaymentRowTo,
    EVHistoryPaymentRowAmount,
    EVHistoryPaymentRowFor,
    EVHistoryPaymentRowDate,
    EVHistoryPaymentRowCOUNT
} EVHistoryPaymentRow;

@interface EVHistoryPaymentViewController : EVHistoryItemViewController<EVReloadable>

- (id)initWithPayment:(EVPayment *)payment;

@end
