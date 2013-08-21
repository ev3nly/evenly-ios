//
//  EVWalletViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSidePanelViewController.h"

typedef enum {
    EVWalletRowCash,
    EVWalletRowCards,
    EVWalletRowBanks,
    EVWalletRowCOUNT
} EVWalletRow;

typedef enum {
    EVWalletSectionWallet,
    EVWalletSectionPending,
    EVWalletSectionCOUNT
} EVWalletSection;

@interface EVWalletViewController : EVSidePanelViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
