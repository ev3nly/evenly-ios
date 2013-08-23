//
//  EVHistoryDepositViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryAbstractViewController.h"
#import "EVWithdrawal.h"

typedef enum {
    EVHistoryDepositRowBank,
    EVHistoryDepositRowAmount,
    EVHistoryDepositRowDate,
    EVHistoryDepositRowCOUNT
} EVHistoryDepositRow;

@interface EVHistoryDepositViewController : EVHistoryAbstractViewController

- (id)initWithWithdrawal:(EVWithdrawal *)withdrawal;

@end
