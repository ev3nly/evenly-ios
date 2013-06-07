//
//  EVWalletViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletViewController.h"
#import "EVNavigationManager.h"
#import "EVWalletCell.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"

@interface EVWalletViewController ()

@end

@implementation EVWalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [EVColor sidePanelBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[EVWalletCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"View will appear");
    [[EVCIA sharedInstance] reloadBankAccountsWithCompletion:^(NSArray *bankAccounts) {
        [self.tableView reloadData];
    }];
    
    [[EVCIA sharedInstance] reloadCreditCardsWithCompletion:^(NSArray *creditCards) {
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[[EVCIA sharedInstance] pendingReceivedTransactions] count])
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[EVCIA sharedInstance] pendingReceivedTransactions] count] && section == 0)
        return [[[EVCIA sharedInstance] pendingReceivedTransactions] count];
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVWalletCell *cell = (EVWalletCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *title = nil;
    NSString *value = nil;
    switch (indexPath.row) {
        case EVWalletRowCash:
            title = @"Cash";
            value = [EVStringUtility amountStringForAmount:[[[EVCIA sharedInstance] me] balance]];
            break;
        case EVWalletRowCards:
        {
            
            title = @"Cards";
            EVCreditCard *activeCard = [[EVCIA sharedInstance] activeCreditCard];
            if (activeCard) {
                value = [activeCard lastFour];
            } else {
                value = @"none";
            }
            break;
        }
        case EVWalletRowBanks:
        {
            title = @"Banks";
            EVBankAccount *activeAccount = [[EVCIA sharedInstance] activeBankAccount];
            if (activeAccount) {
                value = [activeAccount name];
            } else {
                value = @"none";
            }
            break;
        }
        case EVWalletRowHistory:
            title = @"History";
            value = @"A BILLION";
            break;
        default:
            break;
    }
    cell.titleLabel.text = title;
    cell.valueLabel.text = value;
    
    return cell;
}


#pragma mark - EVSidePanelViewController Overrides

- (JASidePanelState)visibleState {
    return JASidePanelRightVisible;
}

@end
