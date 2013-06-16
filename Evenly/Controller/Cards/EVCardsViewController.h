//
//  EVCardsViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

typedef enum {
    EVCardsSectionCards,
    EVCardsSectionAddNew,
    EVCardsSectionCOUNT
} EVCardsSection;

typedef enum {
    EVCardsAddNewRowCredit,
    EVCardsAddNewRowDebit,
    EVCardsAddNewRowCOUNT
} EVCardsAddNewRow;

@interface EVCardsViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@end
