//
//  EVCardsViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSourceViewController.h"

typedef enum {
    EVCardsAddNewRowCredit,
    EVCardsAddNewRowDebit,
    EVCardsAddNewRowCOUNT
} EVCardsAddNewRow;

@interface EVCardsViewController : EVFundingSourceViewController <UITableViewDataSource, UITableViewDelegate>

@end
