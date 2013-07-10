//
//  EVHistoryViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryViewController.h"
#import "EVHistoryCell.h"
#import "EVActivity.h"
#import "EVExchange.h"
#import "EVWithdrawal.h"

#define CELL_HEIGHT 60

@interface EVHistoryViewController ()

@property (nonatomic, strong) UITableView *tableView;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.exchanges = [[EVCIA sharedInstance] history];
    if (!self.exchanges)
        self.tableView.loading = YES;

    [[EVCIA sharedInstance] reloadHistoryWithCompletion:^(NSArray *history) {
        self.tableView.loading = NO;
        self.exchanges = history;
        [self.tableView reloadData];
    }];
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
    [self.tableView registerClass:[EVHistoryCell class] forCellReuseIdentifier:@"historyCell"];
    [self.view addSubview:self.tableView];
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

    return [EVHistoryCell heightGivenSubtitle:subtitle];
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
    [cell setTitle:[self displayStringForDate:historyItem.createdAt] subtitle:subtitle amount:amount];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //load transaction detail controller
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height -= (44 - 20);
    return tableFrame;
}

#pragma mark - Utility

- (NSString *)displayStringForDate:(NSDate *)date {
    return [[[[self class] dateFormatter] stringFromDate:date] uppercaseString];
}

@end
