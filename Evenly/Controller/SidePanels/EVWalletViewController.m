//
//  EVWalletViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletViewController.h"
#import "EVNavigationManager.h"
#import "EVWalletItemCell.h"
#import "EVWalletStamp.h"
#import "EVPendingExchangeCell.h"
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
    
    [self.tableView registerClass:[EVWalletItemCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[EVPendingExchangeCell class] forCellReuseIdentifier:@"pendingCell"];
    [self.view addSubview:self.tableView];
    
    self.walletHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.walletHeader.label.text = @"WALLET";
    
    self.pendingHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.pendingHeader.label.text = @"PENDING";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"View will appear");
    
    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
        DLog(@"Pending exchanges: %@", [self pendingExchanges]);
        [self.tableView reloadData];
    }];
    [[EVCIA sharedInstance] reloadBankAccountsWithCompletion:^(NSArray *bankAccounts) {
        [self.tableView reloadData];
    }];
    
    [[EVCIA sharedInstance] reloadCreditCardsWithCompletion:^(NSArray *creditCards) {
        [self.tableView reloadData];
    }];
}

- (NSArray *)pendingExchanges {
    return [[EVCIA sharedInstance] pendingReceivedExchanges];
}

- (BOOL)hasPendingExchanges {
    return [[self pendingExchanges] count] > 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self hasPendingExchanges])
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasPendingExchanges] && section == EVWalletSectionPending)
        return [[self pendingExchanges] count];
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self hasPendingExchanges] && section == EVWalletSectionPending)
        return self.pendingHeader;
    return self.walletHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasPendingExchanges] && indexPath.section == EVWalletSectionPending)
    {
        EVExchange *exchange = (EVExchange *)[[self pendingExchanges] objectAtIndex:indexPath.row];
        return [EVPendingExchangeCell sizeForExchange:exchange].height;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self hasPendingExchanges] && indexPath.section == EVWalletSectionPending)
    {
        EVPendingExchangeCell *cell = (EVPendingExchangeCell *)[tableView dequeueReusableCellWithIdentifier:@"pendingCell" forIndexPath:indexPath];
        EVExchange *exchange = (EVExchange *)[[self pendingExchanges] objectAtIndex:indexPath.row];
        [cell.avatarView setImage:[[exchange from] avatar]];
        NSString *text = [EVStringUtility stringForExchange:exchange];
        cell.label.text = text;
        [cell.label sizeToFit];
        
        
        return cell;
    }
    
    EVWalletItemCell *cell = (EVWalletItemCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
                DLog(@"activeCard brand: %@", activeCard.brand);
                EVWalletStamp *stamp = [[EVWalletStamp alloc] initWithText:activeCard.brand
                                                                  maxWidth:100];
                cell.stamp = stamp;

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
                value = [[activeAccount accountNumber] substringFromIndex:[activeAccount accountNumber].length - 4];
                EVWalletStamp *stamp = [[EVWalletStamp alloc] initWithText:activeAccount.bankName
                                                                  maxWidth:100];
                cell.stamp = stamp;
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
