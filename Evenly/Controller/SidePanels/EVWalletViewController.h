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
    EVWalletRowHistory
} EVWalletRow;

@interface EVWalletViewController : EVSidePanelViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@end
