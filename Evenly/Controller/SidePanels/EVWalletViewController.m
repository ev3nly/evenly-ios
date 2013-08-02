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
#import "EVGroupRequest.h"
#import "EVWalletNotification.h"

#import "EVDepositViewController.h"
#import "EVCardsViewController.h"
#import "EVBanksViewController.h"
#import "EVHistoryViewController.h"
#import "EVPendingDetailViewController.h"
#import "EVPendingGroupViewController.h"
#import "EVGroupRequestDashboardViewController.h"
#import "EVWalletNotificationViewController.h"

#import "UIScrollView+SVPullToRefresh.h"

#define EV_WALLET_ROW_HEIGHT 44.0
#define PULL_TO_REFRESH_OFFSET CGPointMake(EV_RIGHT_OVERHANG_MARGIN/2, -5)

@interface EVWalletViewController ()

@property (nonatomic, weak) EVCIA *cia;

@property (nonatomic, strong) EVWalletSectionHeader *walletHeader;
@property (nonatomic, strong) EVWalletSectionHeader *pendingHeader;

@property (nonatomic, strong) UIView *walletFooter;
@property (nonatomic, strong) EVGrayButton *historyButton;
@property (nonatomic, strong) EVGrayButton *depositButton;

@property (nonatomic, strong) NSArray *pendingExchanges;

- (void)loadWalletFooter;

@end

@implementation EVWalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pendingExchanges = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    
    self.walletHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.walletHeader.label.text = @"WALLET";
    
    self.pendingHeader = [[EVWalletSectionHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.pendingHeader.label.text = @"PENDING";
    
    [self loadWalletFooter];
    
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

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [EVColor sidePanelBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    [self.tableView registerClass:[EVWalletItemCell class] forCellReuseIdentifier:@"walletItemCell"];
    [self.tableView registerClass:[EVPendingExchangeCell class] forCellReuseIdentifier:@"pendingCell"];
    [self.tableView registerClass:[EVNoPendingExchangesCell class] forCellReuseIdentifier:@"noPendingCell"];
    
    [self.view addSubview:self.tableView];
    
    __block EVWalletViewController *walletController = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
            [walletController.tableView.pullToRefreshView stopAnimating];
        }];
        [[EVCIA sharedInstance] reloadCreditCardsWithCompletion:NULL];
        [[EVCIA sharedInstance] reloadBankAccountsWithCompletion:NULL];
    }];
    self.tableView.pullToRefreshViewOffset = PULL_TO_REFRESH_OFFSET;
}

- (void)loadWalletFooter {
    
    CGFloat xOrigin = EV_RIGHT_OVERHANG_MARGIN;
    CGFloat buttonMargin = EV_WALLET_CELL_MARGIN;
    CGFloat buttonWidth = (self.view.frame.size.width - xOrigin - 3*buttonMargin) / 2.0;
    CGFloat buttonHeight = 35.0;
    CGFloat yMargin = 5.0;
    
    self.historyButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(xOrigin + buttonMargin,
                                                                        yMargin,
                                                                        buttonWidth,
                                                                        buttonHeight)];
    [self.historyButton setTitle:@"HISTORY" forState:UIControlStateNormal];
    [self.historyButton addTarget:self action:@selector(historyButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    self.depositButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(xOrigin + 2*buttonMargin + buttonWidth,
                                                                        yMargin,
                                                                        buttonWidth,
                                                                        buttonHeight)];
    [self.depositButton setTitle:@"DEPOSIT" forState:UIControlStateNormal];
    [self.depositButton addTarget:self action:@selector(depositButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    self.walletFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2*yMargin + buttonHeight)];
    [self.walletFooter addSubview:self.historyButton];
    [self.walletFooter addSubview:self.depositButton];
}

- (void)setUpReactions {
    // RACAble prefers to operate on properties of self, so we can make the CIA a property of self
    // for a little syntactic sugar.
    self.cia = [EVCIA sharedInstance];
    [RACAble(self.cia.me.balance) subscribeNext:^(NSDecimalNumber *balance) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowCash inSection:EVWalletSectionWallet] ]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
}

- (void)exchangesDidUpdate:(NSNotification *)notification {
    self.pendingExchanges = [self.cia pendingExchanges];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:EVWalletSectionPending] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [[EVNavigationManager sharedManager] setPendingNotifications:[self.pendingExchanges count] shouldFlag:[self hasPendingReceivedExchanges]];
}

- (void)creditCardsDidUpdate:(NSNotification *)notification {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowCards
                                                                 inSection:EVWalletSectionWallet] ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)bankAccountsDidUpdate:(NSNotification *)notification {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVWalletRowBanks
                                                                 inSection:EVWalletSectionWallet] ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
}

- (BOOL)hasPendingExchanges {
    return [self.pendingExchanges count] > 0;
}

- (BOOL)hasPendingReceivedExchanges {
    BOOL hasReceived = [[[EVCIA sharedInstance] pendingReceivedExchanges] count] > 0;
    BOOL hasNotification = [[self.pendingExchanges objectAtIndex:0] isKindOfClass:[EVWalletNotification class]];
    return hasReceived || hasNotification;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EVWalletSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if (section == EVWalletSectionPending)
    {
        if ([self hasPendingExchanges])
            count = [self.pendingExchanges count];
        else
            count = 1;
    }
    else
    {
        count = EVWalletRowCOUNT;
    }
    return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == EVWalletSectionPending)
        headerView = self.pendingHeader;
    else
        headerView = self.walletHeader;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == EVWalletSectionWallet)
        return self.walletFooter;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == EVWalletSectionWallet)
        return 45.0;
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVWalletSectionPending)
    {
        if ([self hasPendingExchanges])
        {
            EVExchange *exchange = (EVExchange *)[self.pendingExchanges objectAtIndex:indexPath.row];
            return [EVPendingExchangeCell sizeForInteraction:exchange].height;
        }
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVWalletSectionPending)
    {
        return [self pendingCellForRowAtIndexPath:indexPath];
    }
    if (indexPath.section == EVWalletSectionWallet)
    {
        return [self walletCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (EVPendingExchangeCell *)pendingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVPendingExchangeCell *cell = nil;
    if ([self hasPendingExchanges])
    {
        cell = (EVPendingExchangeCell *)[self.tableView dequeueReusableCellWithIdentifier:@"pendingCell"
                                                                             forIndexPath:indexPath];
        EVExchange *exchange = (EVExchange *)[self.pendingExchanges objectAtIndex:indexPath.row];
        [cell.avatarView setImage:[exchange avatar]];
        [cell configureForInteraction:exchange];
    }
    else
    {
        cell = (EVPendingExchangeCell *)[self.tableView dequeueReusableCellWithIdentifier:@"noPendingCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



- (EVWalletItemCell *)walletCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVWalletItemCell *cell = (EVWalletItemCell *)[self.tableView dequeueReusableCellWithIdentifier:@"walletItemCell" forIndexPath:indexPath];
    cell.accessoryView.hidden = NO;
    cell.shouldHighlight = YES;
    NSString *title = nil;
    NSString *value = nil;
    switch (indexPath.row) {
        case EVWalletRowCash:
        {
            title = @"Cash";
            value = [EVStringUtility amountStringForAmount:[[[EVCIA sharedInstance] me] balance]];
            cell.accessoryView.hidden = YES;
            cell.shouldHighlight = NO;
            break;
        }
        case EVWalletRowCards:
        {
            
            title = @"Cards";
            if ([[EVCIA sharedInstance] loadingCreditCards])
            {
                value = @"Loading...";
            }
            else
            {
                EVCreditCard *activeCard = [[EVCIA sharedInstance] activeCreditCard];
                if (activeCard) {
                    value = [NSString stringWithFormat:@"***%@", [activeCard lastFour]];
                    EVWalletStamp *stamp = [[EVWalletStamp alloc] initWithText:activeCard.brand
                                                                      maxWidth:70];
                    stamp.textColor = [EVColor darkColor];
                    cell.stamp = stamp;
                    
                } else {
                    value = @"Add a card";
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
                value = @"Loading...";
            }
            else
            {
                EVBankAccount *activeAccount = [[EVCIA sharedInstance] activeBankAccount];
                if (activeAccount) {
                    value = [[activeAccount accountNumber] substringFromIndex:[activeAccount accountNumber].length - 4];
                    value = [NSString stringWithFormat:@"***%@", value];
                    EVWalletStamp *stamp = [[EVWalletStamp alloc] initWithText:activeAccount.bankName
                                                                      maxWidth:70];
                    stamp.textColor = [EVColor darkColor];
                    
                    cell.stamp = stamp;
                } else {
                    value = @"Add a bank";
                    cell.stamp = nil;
                }
            }
            break;
        }
        default:
            break;
    }
    cell.titleLabel.text = title;
    cell.valueLabel.text = value;
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVWalletSectionPending && ![self hasPendingExchanges])
        return nil;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == EVWalletSectionPending) {
        EVObject *interaction = (EVObject *)[self.pendingExchanges objectAtIndex:indexPath.row];
        UIViewController *controller = nil;
        if ([interaction isKindOfClass:[EVExchange class]])
        {
            controller = [[EVPendingDetailViewController alloc] initWithExchange:(EVExchange *)interaction];
            
        }
        else if ([interaction isKindOfClass:[EVGroupRequest class]])
        {
            EVGroupRequest *groupRequest = (EVGroupRequest *)interaction;
            if (groupRequest.from == nil)
                controller = [[EVGroupRequestDashboardViewController alloc] initWithGroupRequest:groupRequest];
            else
                controller = [[EVPendingGroupViewController alloc] initWithGroupRequest:groupRequest];
        }
        else if ([interaction isKindOfClass:[EVWalletNotification class]])
        {
            controller = [[EVWalletNotificationViewController alloc] initWithWalletNotification:(EVWalletNotification *)interaction];
        }
        NSAssert1(controller != nil, @"Controller to be presented was nil!  The object we were making the controller for was %@", interaction);
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else     if (indexPath.section == EVWalletSectionWallet) {
        if (indexPath.row == EVWalletRowCards)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVCardsViewController alloc] init]];
            [self presentViewController:navController animated:YES completion:NULL];
        }
        else if (indexPath.row == EVWalletRowBanks)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVBanksViewController alloc] init]];
            [self presentViewController:navController animated:YES completion:NULL];
        }
    }
}

- (void)historyButtonPress:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[EVHistoryViewController new]];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)depositButtonPress:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVDepositViewController alloc] init]];
    [self presentViewController:navController animated:YES completion:NULL];
}

#pragma mark - EVSidePanelViewController Overrides

- (JASidePanelState)visibleState {
    return JASidePanelRightVisible;
}

@end
