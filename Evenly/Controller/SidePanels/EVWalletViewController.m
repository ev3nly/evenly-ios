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
#import "EVPendingTransactionCell.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"
#import "EVExchange.h"



@interface EVWalletViewController ()

@property (nonatomic, strong) EVWalletSectionHeader *walletHeader;
@property (nonatomic, strong) EVWalletSectionHeader *pendingHeader;

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
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerClass:[EVWalletCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[EVPendingTransactionCell class] forCellReuseIdentifier:@"pendingCell"];
    [self.view addSubview:self.tableView];
    
    self.walletHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.walletHeader.label.text = @"WALLET";
    
    self.pendingHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.pendingHeader.label.text = @"PENDING";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"View will appear");
    
    [[EVCIA sharedInstance] reloadAllWithCompletion:^{
        DLog(@"Pending transactions: %@", [[EVCIA sharedInstance] pendingReceivedTransactions]);
    }];
    [[EVCIA sharedInstance] reloadBankAccountsWithCompletion:^(NSArray *bankAccounts) {
        [self.tableView reloadData];
    }];
    
    [[EVCIA sharedInstance] reloadCreditCardsWithCompletion:^(NSArray *creditCards) {
        [self.tableView reloadData];
    }];
}

- (BOOL)hasPendingTransactions {
    return [[[EVCIA sharedInstance] pendingReceivedTransactions] count] > 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self hasPendingTransactions])
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasPendingTransactions] && section == EVWalletSectionPending)
        return [[[EVCIA sharedInstance] pendingReceivedTransactions] count];
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self hasPendingTransactions] && section == EVWalletSectionPending)
        return self.pendingHeader;
    return self.walletHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasPendingTransactions] && indexPath.section == EVWalletSectionPending)
    {
        EVExchange *exchange = (EVExchange *)[[[EVCIA sharedInstance] pendingReceivedTransactions] objectAtIndex:indexPath.row];
        return [EVPendingTransactionCell sizeForTransaction:exchange].height;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self hasPendingTransactions] && indexPath.section == EVWalletSectionPending)
    {
        EVPendingTransactionCell *cell = (EVPendingTransactionCell *)[tableView dequeueReusableCellWithIdentifier:@"pendingCell" forIndexPath:indexPath];
        EVExchange *exchange = (EVExchange *)[[[EVCIA sharedInstance] pendingReceivedTransactions] objectAtIndex:indexPath.row];
        [cell.avatarView setImage:[(EVUser *)[exchange from] avatar]];
        NSString *text = [EVStringUtility stringForExchange:exchange];
        cell.label.text = text;
        [cell.label sizeToFit];
        return cell;
    }
    
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
            value = EV_STRING_FROM_INT([[[EVCIA sharedInstance] history] count]);
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
