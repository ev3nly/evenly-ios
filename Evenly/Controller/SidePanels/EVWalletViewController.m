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

#import "EVDepositViewController.h"
#import "EVCardsViewController.h"
#import "EVBanksViewController.h"
#import "EVHistoryViewController.h"
#import "EVPendingDetailViewController.h"

#define EV_WALLET_ROW_HEIGHT 44.0

@interface EVWalletViewController ()

@property (nonatomic, weak) EVCIA *cia;

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
    [self loadWalletTableView];
    [self loadPendingTableView];
    
    self.walletHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.walletHeader.label.text = @"WALLET";
    
    self.pendingHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.pendingHeader.label.text = @"PENDING";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exchangesDidUpdate:)
                                                 name:EVCIAUpdatedExchangesNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditCardsDidUpdate:)
                                                 name:EVCIAUpdatedCreditCardsNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bankAccountsDidUpdate:)
                                                 name:EVCIAUpdatedBankAccountsNotification
                                               object:nil];
    [self setUpReactions];
}

- (void)loadWalletTableView {
    
    CGFloat totalHeight = ((EVWalletRowCOUNT+1) * EV_WALLET_ROW_HEIGHT);
    self.walletTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                         self.view.frame.size.height - totalHeight,
                                                                         self.view.frame.size.width,
                                                                         totalHeight)
                                                        style:UITableViewStylePlain];
    
    self.walletTableView.delegate = self;
    self.walletTableView.dataSource = self;
    self.walletTableView.backgroundColor = [EVColor sidePanelBackgroundColor];
    self.walletTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.walletTableView.separatorColor = [UIColor clearColor];
    self.walletTableView.scrollEnabled = NO;
    [self.walletTableView registerClass:[EVWalletItemCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.walletTableView];
}

- (void)loadPendingTableView {
    self.pendingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.view.frame.size.width,
                                                                          CGRectGetMinY(self.walletTableView.frame))
                                                         style:UITableViewStylePlain];
    self.pendingTableView.delegate = self;
    self.pendingTableView.dataSource = self;
    self.pendingTableView.backgroundColor = [EVColor sidePanelBackgroundColor];
    self.pendingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pendingTableView.separatorColor = [UIColor clearColor];
    self.pendingTableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    [self.pendingTableView registerClass:[EVPendingExchangeCell class] forCellReuseIdentifier:@"pendingCell"];
    [self.pendingTableView registerClass:[EVNoPendingExchangesCell class] forCellReuseIdentifier:@"noPendingCell"];

    [self.view addSubview:self.pendingTableView];
}

- (void)setUpReactions {
    // RACAble prefers to operate on properties of self, so we can make the CIA a property of self
    // for a little syntactic sugar.
    self.cia = [EVCIA sharedInstance];
    [RACAble(self.cia.me.balance) subscribeNext:^(NSDecimalNumber *balance) {
        [self.walletTableView beginUpdates];
        [self.walletTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowCash inSection:0] ]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.walletTableView endUpdates];
    }];
}

- (void)exchangesDidUpdate:(NSNotification *)notification {
    [self.pendingTableView beginUpdates];
    [self.pendingTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.pendingTableView endUpdates];
    
    // Reload History cell.
    [self.walletTableView beginUpdates];
    [self.walletTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowHistory
                                                                       inSection:0] ]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.walletTableView endUpdates];
}

- (void)creditCardsDidUpdate:(NSNotification *)notification {
    [self.walletTableView beginUpdates];
    [self.walletTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowCards
                                                                       inSection:0] ]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.walletTableView endUpdates];
}

- (void)bankAccountsDidUpdate:(NSNotification *)notification {
    [self.walletTableView beginUpdates];
    [self.walletTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowBanks
                                                                       inSection:0] ]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.walletTableView endUpdates];
    
}

- (NSArray *)pendingExchanges {
    return [[EVCIA sharedInstance] pendingReceivedExchanges];
}

- (BOOL)hasPendingExchanges {
    return [[self pendingExchanges] count] > 0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if (tableView == self.pendingTableView)
    {
        if ([self hasPendingExchanges])
            count = [[self pendingExchanges] count];
        else
            count = 1;
    }
    else
    {
        count = 4;
    }
    return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (tableView == self.pendingTableView)
        headerView = self.pendingHeader;
    else
        headerView = self.walletHeader;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.pendingTableView)
    {
        if ([self hasPendingExchanges])
        {
            EVExchange *exchange = (EVExchange *)[[self pendingExchanges] objectAtIndex:indexPath.row];
            return [EVPendingExchangeCell sizeForExchange:exchange].height;
        }
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.pendingTableView)
    {
        return [self pendingCellForRowAtIndexPath:indexPath];
    }
    if (tableView == self.walletTableView)
    {
        return [self walletCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (EVPendingExchangeCell *)pendingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVPendingExchangeCell *cell = nil;
    if ([self hasPendingExchanges])
    {
        cell = (EVPendingExchangeCell *)[self.pendingTableView dequeueReusableCellWithIdentifier:@"pendingCell"
                                                                                                           forIndexPath:indexPath];
        EVExchange *exchange = (EVExchange *)[[self pendingExchanges] objectAtIndex:indexPath.row];
        [cell.avatarView setImage:[[exchange from] avatar]];
        NSString *text = [EVStringUtility stringForExchange:exchange];
        cell.label.text = text;
        [cell.label sizeToFit];
        
    }
    else
    {
        cell = (EVPendingExchangeCell *)[self.pendingTableView dequeueReusableCellWithIdentifier:@"noPendingCell" forIndexPath:indexPath];
    }
    return cell;
}



- (EVWalletItemCell *)walletCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVWalletItemCell *cell = (EVWalletItemCell *)[self.walletTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
            if ([[EVCIA sharedInstance] loadingCreditCards])
            {
                value = @"loading...";
            }
            else
            {
                EVCreditCard *activeCard = [[EVCIA sharedInstance] activeCreditCard];
                if (activeCard) {
                    value = [activeCard lastFour];
                    DLog(@"activeCard brand: %@", activeCard.brand);
                    EVWalletStamp *stamp = [[EVWalletStamp alloc] initWithText:activeCard.brand
                                                                      maxWidth:100];
                    cell.stamp = stamp;
                    
                } else {
                    value = @"none";
                    cell.stamp = nil;
                }
            }
            break;
        }
        case EVWalletRowBanks:
        {
            title = @"Banks";
            if ([[EVCIA sharedInstance] loadingBankAccounts])
            {
                value = @"loading...";
            }
            else
            {
                EVBankAccount *activeAccount = [[EVCIA sharedInstance] activeBankAccount];
                if (activeAccount) {
                    value = [[activeAccount accountNumber] substringFromIndex:[activeAccount accountNumber].length - 4];
                    EVWalletStamp *stamp = [[EVWalletStamp alloc] initWithText:activeAccount.bankName
                                                                      maxWidth:100];
                    cell.stamp = stamp;
                } else {
                    value = @"none";
                }
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.pendingTableView) {
        EVExchange *exchange = (EVExchange *)[[self pendingExchanges] objectAtIndex:indexPath.row];
        EVStory *story = [EVStory storyFromPendingExchange:exchange];
        EVPendingDetailViewController *pendingController = [[EVPendingDetailViewController alloc] initWithStory:story];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pendingController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else if (tableView == self.walletTableView) {
        if (indexPath.row == EVWalletRowCash)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVDepositViewController alloc] init]];
            [self presentViewController:navController animated:YES completion:NULL];
        }
        else if (indexPath.row == EVWalletRowCards)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVCardsViewController alloc] init]];
            [self presentViewController:navController animated:YES completion:NULL];
        }
        else if (indexPath.row == EVWalletRowBanks)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVBanksViewController alloc] init]];
            [self presentViewController:navController animated:YES completion:NULL];
        }
        else if (indexPath.row == EVWalletRowHistory)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[EVHistoryViewController new]];
            [self presentViewController:navController animated:YES completion:NULL];
        }
    }
}


#pragma mark - EVSidePanelViewController Overrides

- (JASidePanelState)visibleState {
    return JASidePanelRightVisible;
}

@end
