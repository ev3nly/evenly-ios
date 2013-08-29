//
//  EVHomeViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHomeViewController.h"
#import "EVUser.h"
#import "EVStory.h"
#import "EVStoryCell.h"
#import "EVFloatingRequestButton.h"
#import "EVFloatingPaymentButton.h"
#import "EVPaymentViewController.h"
#import "EVRequestViewController.h"
#import "EVTippingViewController.h"
#import "EVStoryDetailViewController.h"
#import "EVNavigationManager.h"
#import "EVSetPINViewController.h"

#import "EVRewardsGameViewController.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "EVLoadingIndicator.h"
#import "EVSettingsManager.h"

#import "EVGettingStartedViewController.h"

#import "AMBlurView.h"

#define TABLE_VIEW_LOADING_INDICATOR_Y_OFFSET -50
#define TABLE_VIEW_INFINITE_SCROLLING_INSET 40
#define TABLE_VIEW_INFINITE_SCROLL_VIEW_OFFSET -7

@interface EVHomeViewController ()

@property (nonatomic, weak) EVCIA *cia;

@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *newsfeed;
@property (nonatomic, strong) NSMutableArray *locallyCreatedStories;

@property (nonatomic) int pageNumber;

- (void)configurePullToRefresh;

@end

@implementation EVHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Evenly";
        self.pageNumber = 1;
        self.locallyCreatedStories = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadBalanceLabel];
    [self loadWalletBarButtonItem];
    
    [self loadTableView];
    [self loadFloatingView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadBalanceLabel {
    self.title = [EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance];
    
    // RACAble prefers to operate on properties of self, so we can make the CIA a property of self
    // for a little syntactic sugar.  Sugar... mhmmmmm
    self.cia = [EVCIA sharedInstance];
    [RACAble(self.cia.me.balance) subscribeNext:^(NSDecimalNumber *balance) {
        self.title = [EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance];
    }];
}

- (void)loadTableView {
    self.newsfeedDataSource = [[EVNewsfeedDataSource alloc] init];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self.newsfeedDataSource;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    self.tableView.backgroundView = nil;
    self.tableView.loadingIndicatorYOffset = TABLE_VIEW_LOADING_INDICATOR_Y_OFFSET;
    [self.tableView registerClass:[EVStoryCell class] forCellReuseIdentifier:@"storyCell"];
    [self.view addSubview:self.tableView];

    [self configurePullToRefresh];
    [self configureInfiniteScrolling];
    [self.newsfeedDataSource setTableView:self.tableView];
    [self.newsfeedDataSource loadNewestStories];
    
}

- (void)loadFloatingView {
    
    self.requestButton = [[EVFloatingRequestButton alloc] init];
    [self.requestButton addTarget:self
                           action:@selector(requestButtonPress:)
                 forControlEvents:UIControlEventTouchUpInside];
    self.payButton = [[EVFloatingPaymentButton alloc] init];
    [self.payButton addTarget:self
                           action:@selector(payButtonPress:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat x, y, width, height;
    y = self.view.frame.size.height - self.requestButton.frame.size.height;
    width = self.requestButton.frame.size.width + self.payButton.frame.size.width;
    x = (int)((self.view.frame.size.width - width) / 2.0) + 1;
    height = self.requestButton.frame.size.height;
    self.floatingView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.floatingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.floatingView addSubview:self.requestButton];
    [self.floatingView addSubview:self.payButton];
    
    [self.view addSubview:self.floatingView];
}


- (void)updateTableViewContentInset {
    UIEdgeInsets insets = UIEdgeInsetsMake([self totalBarHeight],
                                           0,
                                           TABLE_VIEW_INFINITE_SCROLLING_INSET,
                                           0);
    self.tableView.contentInset = insets;
}


- (void)configurePullToRefresh {
    __weak EVHomeViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.newsfeedDataSource loadNewestStories];
        [EVCIA reloadMe];
    }];
    self.tableView.pullToRefreshView.originalTopInset = [self totalBarHeight];
}

- (void)configureInfiniteScrolling {
    __weak EVHomeViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.newsfeedDataSource loadNextPage];
    }];
    
    self.tableView.infiniteScrollingView.customViewOffset = TABLE_VIEW_INFINITE_SCROLL_VIEW_OFFSET;
    [self.tableView.infiniteScrollingView setCustomView:self.newsfeedDataSource.loadingIndicator
                                               forState:SVInfiniteScrollingStateLoading];
    [self.tableView.infiniteScrollingView setCustomView:[[UIImageView alloc] initWithImage:[EVImages grayLoadingLogo]]
                                               forState:SVInfiniteScrollingStateReachedEnd];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Button Actions

- (void)requestButtonPress:(id)sender {
    
    if ([EVCIA me].needsRequestHelp) {
        EVGettingStartedViewController *gettingStartedController = [[EVGettingStartedViewController alloc] initWithType:EVGettingStartedTypeRequest];
        gettingStartedController.controllerToShow = [EVRequestViewController new];
        EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:gettingStartedController];
        [self presentViewController:navController animated:YES completion:NULL];
    }
    else {
        EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[[EVRequestViewController alloc] init]];
        [self presentViewController:navController animated:YES completion:NULL];
    }
}

- (void)payButtonPress:(id)sender {
    
    if ([EVCIA me].needsPaymentHelp) {
        EVGettingStartedViewController *gettingStartedController = [[EVGettingStartedViewController alloc] initWithType:EVGettingStartedTypePayment];
        gettingStartedController.controllerToShow = [EVPaymentViewController new];
        EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:gettingStartedController];
        [self presentViewController:navController animated:YES completion:NULL];
    }
    else {
        EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[[EVPaymentViewController alloc] init]];
        [self presentViewController:navController animated:YES completion:NULL];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = (int)[EVStoryCell cellHeightForStory:[self.newsfeedDataSource.newsfeed objectAtIndex:indexPath.section]];
    if ((int)height % 2 != 0)
        height += 1; //the grouped cells don't play nice with odd heights
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVStory *story = [self.newsfeedDataSource.newsfeed objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:[[EVStoryDetailViewController alloc] initWithStory:story] animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
