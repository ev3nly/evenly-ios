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

#import "EVRewardsGameViewController.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "EVLoadingIndicator.h"

#define TABLE_VIEW_LOADING_INDICATOR_Y_OFFSET -20

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
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [self loadBalanceLabel];
    [self loadWalletBarButtonItem];
    [self loadTableView];
    [self loadFloatingView];
    [self configurePullToRefresh];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignIn:) name:EVSessionSignedInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOut:) name:EVSessionSignedOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storyWasCreatedLocally:) name:EVStoryLocallyCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardRedeemed:) name:EVRewardRedeemedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadBalanceLabel {
    [self setTitle:[EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance]];
    
    // RACAble prefers to operate on properties of self, so we can make the CIA a property of self
    // for a little syntactic sugar.  Sugar... mhmmmmm
    self.cia = [EVCIA sharedInstance];
    [RACAble(self.cia.me.balance) subscribeNext:^(NSDecimalNumber *balance) {
        [self setTitle:[EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance]];
    }];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    self.tableView.backgroundView = nil;
    self.tableView.loadingIndicatorYOffset = TABLE_VIEW_LOADING_INDICATOR_Y_OFFSET;
    [self.tableView registerClass:[EVStoryCell class] forCellReuseIdentifier:@"storyCell"];
    [self.view addSubview:self.tableView];
    
    EVLoadingIndicator *customLoadingIndicator = [[EVLoadingIndicator alloc] initWithFrame:CGRectZero];
    [customLoadingIndicator sizeToFit];
    __weak EVHomeViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.pageNumber++;
        DLog(@"Page number: %d", weakSelf.pageNumber);
        [weakSelf.tableView.infiniteScrollingView startAnimating];
        [customLoadingIndicator startAnimating];
        [EVUser newsfeedStartingAtPage:weakSelf.pageNumber
                              success:^(NSArray *history) {
                                  if ([history count] == 0) {
                                      weakSelf.pageNumber--;
                                      DLog(@"No entries, reverted page number to %d", weakSelf.pageNumber);
                                  }
                                  weakSelf.newsfeed = [weakSelf.newsfeed arrayByAddingObjectsFromArray:history];
                                  [weakSelf.tableView reloadData];
                                  [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                  [customLoadingIndicator stopAnimating];
                                  
                              } failure:^(NSError *error) {
                                  DLog(@"error: %@", error);
                                  weakSelf.pageNumber--;
                                  DLog(@"Error, reverted page number to %d", weakSelf.pageNumber);
                                  [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                  [customLoadingIndicator stopAnimating];
                              }];
    }];
    [self.tableView.infiniteScrollingView setCustomView:customLoadingIndicator
                                               forState:SVInfiniteScrollingStateLoading];
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
    
    [self updateTableViewContentInset];
}

- (void)updateTableViewContentInset {
    self.tableView.contentInset = UIEdgeInsetsMake(0,
                                                   0,
                                                   self.floatingView.frame.size.height + self.tableView.infiniteScrollingView.frame.size.height,
                                                   0);
}

- (void)configurePullToRefresh {
    __block EVHomeViewController *homeController = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [homeController reloadNewsFeed];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self reloadNewsFeed];
}

- (void)didSignIn:(NSNotification *)notification {
    [self reloadNewsFeed];
}

- (void)didSignOut:(NSNotification *)notification {
    self.newsfeed = [NSArray array];
    [self.tableView reloadData];
}

- (void)reloadNewsFeed {
    if ([self.newsfeed count] == 0) {
        self.tableView.loading = YES;
        [self.tableView setShowsInfiniteScrolling:NO];
    }

    [EVUser newsfeedWithSuccess:^(NSArray *newsfeed) {
        self.newsfeed = newsfeed;
        
        [self compareLocalStories];        
        
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        self.tableView.loading = NO;
        [self.tableView setShowsInfiniteScrolling:YES];
        EV_DISPATCH_AFTER(0.5, ^{
            [self updateTableViewContentInset];
        });
    } failure:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        self.tableView.loading = NO;
        [self.tableView setShowsInfiniteScrolling:YES];
        EV_DISPATCH_AFTER(0.5, ^{
            [self updateTableViewContentInset];
        });
    }];
}

- (void)compareLocalStories {
    if ([self.locallyCreatedStories count] == 0)
        return;
    
    EVStory *mostRecentLocalStory = [self.locallyCreatedStories objectAtIndex:0];
    EVStory *mostRecentRemoteStory = [self.newsfeed objectAtIndex:0];
    
    // Remote story is older than local story
    if ([mostRecentRemoteStory.createdAt compare:mostRecentLocalStory.createdAt] == NSOrderedAscending) {
        
        // Remove stories older than an hour.
        NSArray *locals = [NSArray arrayWithArray:self.locallyCreatedStories];
        NSDate *anHourAgo = [NSDate dateWithTimeIntervalSinceNow:(-EVStoryLocalMaxLifespan)];
        for (EVStory *localStory in locals) {
            if ([[localStory createdAt] isEarlierThan:anHourAgo]) {
                [self.locallyCreatedStories removeObject:localStory];
            }
        }
    }
    // Remote story is newer than most recent local story
    else {
        [self.locallyCreatedStories removeAllObjects];
    }
    
    if ([self.locallyCreatedStories count] > 0) {
        self.newsfeed = [self.locallyCreatedStories arrayByAddingObjectsFromArray:self.newsfeed];
    }
}

- (void)storyWasCreatedLocally:(NSNotification *)notification {
    EVStory *story = [[notification userInfo] objectForKey:@"story"];
    [self.locallyCreatedStories insertObject:story atIndex:0];
    
    self.newsfeed = [self.locallyCreatedStories arrayByAddingObjectsFromArray:self.newsfeed];
}

- (void)rewardRedeemed:(NSNotification *)notification {
    EVReward *reward = [[notification userInfo] objectForKey:@"reward"];
    UILabel *label = [[notification userInfo] objectForKey:@"label"];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [EVColor darkColor];

    UIView *slider = [[label superview] superview];
    label.frame = slider.frame;
    [self.view addSubview:label];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGRect destinationFrame = [self.view convertRect:self.titleLabel.frame fromView:self.titleLabel.superview];
                             [label setCenter:CGPointMake(CGRectGetMidX(destinationFrame), CGRectGetMidY(destinationFrame))];
                         } completion:^(BOOL finished) {
                             [label removeFromSuperview];
                             NSDecimalNumber *myBalance = [[EVCIA me] balance];
                             NSDecimalNumber *rewardAmount = reward.selectedAmount;
                             NSDecimalNumber *newBalance = [myBalance decimalNumberByAdding:rewardAmount];
                             [[[EVCIA sharedInstance] me] setBalance:newBalance];
                             NSString *newTitle = [EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance];
                             [self setTitle:newTitle];
                         }];
    }];
}

#pragma mark - Button Actions

- (void)requestButtonPress:(id)sender {
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVTippingViewController alloc] init]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVRequestViewController alloc] init]];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)payButtonPress:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVPaymentViewController alloc] init]];
    [self presentViewController:navController animated:YES completion:NULL];    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self.newsfeed count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVStoryCell cellHeightForStory:[self.newsfeed objectAtIndex:indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    EVStory *story = [self.newsfeed objectAtIndex:indexPath.section];
    cell.story = story;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVStory *story = [self.newsfeed objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:[[EVStoryDetailViewController alloc] initWithStory:story] animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
