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
#import "EVHistoryItem.h"
#import "EVHistoryItemViewController.h"

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"MMMM dd";
    });
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
    
    EVHistoryItem *historyItem = (EVHistoryItem *)[self.exchanges objectAtIndex:indexPath.row];
    NSString *subtitle = [self subtitleForHistoryItem:historyItem];
    return [EVHistoryCell heightGivenSubtitle:subtitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVHistoryCell *cell = (EVHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    EVHistoryItem *historyItem = (EVHistoryItem *)[self.exchanges objectAtIndex:indexPath.row];
    NSString *subtitle = [self subtitleForHistoryItem:historyItem];
    NSDecimalNumber *amount = historyItem.amount;
    [cell setTitle:[self displayStringForDate:historyItem.createdAt] subtitle:subtitle amount:amount];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EVHistoryItem *historyItem = [self.exchanges objectAtIndex:indexPath.row];
    EVHistoryItemViewController *viewController = [[EVHistoryItemViewController alloc] initWithHistoryItem:historyItem];
    [self.navigationController pushViewController:viewController animated:YES];
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

- (NSString *)subtitleForHistoryItem:(EVHistoryItem *)historyItem {
    return historyItem.memo;
    
    NSString *subtitle = @"";
    NSString *memo = historyItem.memo;
    EVObject<EVExchangeable> *exchangeable = nil;
    if ([historyItem.source[@"type"] isEqualToString:@"Payment"])
    {
        if ([historyItem.from.dbid isEqualToString:[EVCIA me].dbid]) {
            exchangeable = historyItem.to;
        }
        else if ([historyItem.to.dbid isEqualToString:[EVCIA me].dbid]) {
            exchangeable = historyItem.from;
        }
    }
    
    if (exchangeable)
    {
        NSString *otherPerson = exchangeable.name;
        if (memo)
            subtitle = [NSString stringWithFormat:@"%@ • %@", otherPerson, historyItem.memo];
        else
            subtitle = otherPerson;
    }
    else
    {
        if (memo)
            subtitle = memo;
    }
    return subtitle;
}

- (NSString *)displayStringForDate:(NSDate *)date {
    NSString *dateString = nil;
    @synchronized ([[self class] dateFormatter])
    {
        dateString = [[[[self class] dateFormatter] stringFromDate:date] uppercaseString];
    }
    return dateString;
}

@end
