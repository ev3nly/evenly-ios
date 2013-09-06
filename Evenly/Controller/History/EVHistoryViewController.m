//
//  EVHistoryViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryViewController.h"
#import "EVHistoryCell.h"
#import "EVExchange.h"
#import "EVWithdrawal.h"
#import "EVReward.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "EVLoadingIndicator.h"
#import "EVStory.h"

#import "EVHistoryPaymentViewController.h"
#import "EVHistoryDepositViewController.h"
#import "EVHistoryRewardViewController.h"

#define CELL_HEIGHT 60
#define TABLE_VIEW_LOADING_INDICATOR_Y_OFFSET ([EVUtilities userHasIOS7] ? -50 : -16)
#define TABLE_VIEW_INFINITE_SCROLLING_INSET 44
#define TABLE_VIEW_INFINITE_SCROLL_VIEW_OFFSET -7

#define NO_HISTORY_LABEL_OFFSET ([EVUtilities userHasIOS7] ? 6 : -20)

@interface EVHistoryViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *noHistoryLabel;
@property (nonatomic) int pageNumber;

- (void)loadTableView;

@end

@implementation EVHistoryViewController

static NSDateFormatter *_dateFormatter = nil;
+ (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"MMMM dd";
    }
    return _dateFormatter;
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"History";
        self.pageNumber = 1;
        self.exchanges = [[EVCIA sharedInstance] history];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    [self reloadHistory];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableView setFrame:[self.view bounds]];
}

#pragma mark - Data Loading

- (void)reloadHistory {
    if ([self.exchanges count] == 0)
        self.tableView.loading = YES;
    [[EVCIA sharedInstance] reloadHistoryWithCompletion:^(NSArray *history) {
        self.tableView.loading = NO;
        self.exchanges = history;
        [self.tableView reloadData];
        
        if ([history count] == 0) {
            if (!self.noHistoryLabel)
                [self loadNoHistoryLabel];
        }
        else if (self.noHistoryLabel) {
            [self.noHistoryLabel removeFromSuperview];
            self.noHistoryLabel = nil;
            [self addInfiniteScrolling];
        }
    }];
}

- (void)addInfiniteScrolling {
    EVLoadingIndicator *customLoadingIndicator = [[EVLoadingIndicator alloc] initWithFrame:CGRectZero];
    [customLoadingIndicator sizeToFit];
    __weak EVHistoryViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.pageNumber++;
        [weakSelf.tableView.infiniteScrollingView startAnimating];
        [customLoadingIndicator startAnimating];
        [EVUser historyStartingAtPage:weakSelf.pageNumber
                              success:^(NSArray *history) {
                                  if ([history count] == 0) {
                                      weakSelf.pageNumber--;
                                      DLog(@"No entries, reverted page number to %d", weakSelf.pageNumber);
                                  }
                                  weakSelf.exchanges = [weakSelf.exchanges arrayByAddingObjectsFromArray:history];
                                  [weakSelf.tableView reloadData];
                                  [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                  [customLoadingIndicator stopAnimating];
                                  
                                  if (!history || [history count] == 0)
                                      [weakSelf.tableView.infiniteScrollingView reachedEnd];
                              } failure:^(NSError *error) {
                                  DLog(@"error: %@", error);
                                  weakSelf.pageNumber--;
                                  [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                  [customLoadingIndicator stopAnimating];
                              }];
    }];
    
    self.tableView.infiniteScrollingView.customViewOffset = TABLE_VIEW_INFINITE_SCROLL_VIEW_OFFSET;
    [self.tableView.infiniteScrollingView setCustomView:[[UIImageView alloc] initWithImage:[EVImages grayLoadingLogo]]
                                               forState:SVInfiniteScrollingStateReachedEnd];
    [self.tableView.infiniteScrollingView setCustomView:customLoadingIndicator
                                               forState:SVInfiniteScrollingStateLoading];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.loadingIndicatorYOffset = TABLE_VIEW_LOADING_INDICATOR_Y_OFFSET;
    [self.tableView registerClass:[EVHistoryCell class] forCellReuseIdentifier:@"historyCell"];
    [self.view addSubview:self.tableView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0,
                                                   0,
                                                   TABLE_VIEW_INFINITE_SCROLLING_INSET,
                                                   0);
}

- (void)loadNoHistoryLabel {
    self.noHistoryLabel = [UILabel new];
    self.noHistoryLabel.backgroundColor = [UIColor clearColor];
    self.noHistoryLabel.text = @"You haven't made any transactions yet!";
    self.noHistoryLabel.textAlignment = NSTextAlignmentCenter;
    self.noHistoryLabel.textColor = [EVColor lightLabelColor];
    self.noHistoryLabel.font = [EVFont defaultFontOfSize:15];
    [self.noHistoryLabel sizeToFit];
    
    self.noHistoryLabel.center = [self noHistoryLabelCenter];
    [self.tableView addSubview:self.noHistoryLabel];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exchanges count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.exchanges)
        return 0;
    EVObject *historyItem = (EVObject *)[self.exchanges objectAtIndex:indexPath.row];
    NSString *subtitle = @"";

    if ([historyItem isKindOfClass:[EVWithdrawal class]]) {
        EVWithdrawal *withdrawal = (EVWithdrawal *)historyItem;
        subtitle = [NSString stringWithFormat:@"Deposit into %@", withdrawal.bankName];
    }
    else if ([historyItem isKindOfClass:[EVExchange class]]) {
        EVExchange *exchange = (EVExchange *)historyItem;
        EVObject<EVExchangeable> *exchangeable = exchange.to ? exchange.to : exchange.from;
        NSString *otherPerson = exchangeable.name ? exchangeable.name : exchangeable.email;
        subtitle = [NSString stringWithFormat:@"%@ • %@", otherPerson, exchange.memo];
    }
    else if ([historyItem isKindOfClass:[EVReward class]]) {
        subtitle = @"Reward";
    }

    float height = (int)[EVHistoryCell heightGivenSubtitle:subtitle];
    if ((int)height % 2 != 0)
        height += 1; //the grouped cells don't play nice with odd heights
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVHistoryCell *cell = (EVHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    EVObject *historyItem = (EVObject *)[self.exchanges objectAtIndex:indexPath.row];

    NSString *subtitle = @"";
    NSDecimalNumber *amount;
    if ([historyItem isKindOfClass:[EVWithdrawal class]]) {
        EVWithdrawal *withdrawal = (EVWithdrawal *)historyItem;
        subtitle = [NSString stringWithFormat:@"Deposit into %@", withdrawal.bankName];
        amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"-%@", [withdrawal.amount stringValue]]];
    }
    else if ([historyItem isKindOfClass:[EVExchange class]]) {
        EVExchange *exchange = (EVExchange *)historyItem;
        EVObject<EVExchangeable> *exchangeable = exchange.to ? exchange.to : exchange.from;
        NSString *otherPerson = exchangeable.name ? exchangeable.name : exchangeable.email;
        subtitle = [NSString stringWithFormat:@"%@ • %@", otherPerson, exchange.memo];
        amount = exchange.amount;
        if (exchange.to)
            amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"-%@", [amount stringValue]]];
    }
    else if ([historyItem isKindOfClass:[EVReward class]]) {
        EVReward *reward = (EVReward *)historyItem;
        subtitle = @"Reward";
        amount = [reward selectedAmount];
    }
    [cell setTitle:[self displayStringForDate:historyItem.createdAt] subtitle:subtitle amount:amount];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVObject *historyItem = (EVObject *)[self.exchanges objectAtIndex:indexPath.row];
    UIViewController *controller = nil;
    if ([historyItem isKindOfClass:[EVPayment class]]) {
        controller = [[EVHistoryPaymentViewController alloc] initWithPayment:(EVPayment *)historyItem];
    } else if ([historyItem isKindOfClass:[EVWithdrawal class]]) {
        controller = [[EVHistoryDepositViewController alloc] initWithWithdrawal:(EVWithdrawal *)historyItem];
    } else if ([historyItem isKindOfClass:[EVReward class]]) {
        controller = [[EVHistoryRewardViewController alloc] initWithReward:(EVReward *)historyItem];
    }
    if (controller)
        [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = self.view.bounds;
    return tableFrame;
}

- (CGPoint)noHistoryLabelCenter {
    CGPoint tableViewCenter = self.tableView.center;
    tableViewCenter.y += self.tableView.contentOffset.y + NO_HISTORY_LABEL_OFFSET;
    return tableViewCenter;
}

#pragma mark - Utility

- (NSString *)displayStringForDate:(NSDate *)date {
    return [[[[self class] dateFormatter] stringFromDate:date] uppercaseString];
}

@end
