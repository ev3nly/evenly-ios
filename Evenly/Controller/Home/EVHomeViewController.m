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
#import "EVPaymentViewController_NEW.h"
#import "EVRequestViewController.h"
#import "EVTransactionDetailViewController.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface EVHomeViewController ()

@property (nonatomic, weak) EVCIA *cia;

@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *newsfeed;

- (void)configurePullToRefresh;

@end

@implementation EVHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Evenly";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [self loadBalanceLabel];
    [self loadRightBarButtonItem];
    [self loadTableView];
    [self loadFloatingView];
    [self configurePullToRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignIn:) name:EVSessionSignedInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOut:) name:EVSessionSignedOutNotification object:nil];
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

- (void)loadRightBarButtonItem {
    UIImage *image = [UIImage imageNamed:@"Wallet"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 14, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self.masterViewController action:@selector(toggleRightPanel:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
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
    [self.tableView registerClass:[EVStoryCell class] forCellReuseIdentifier:@"storyCell"];
    [self.view addSubview:self.tableView];
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.floatingView.frame.size.height, 0);
}

- (void)configurePullToRefresh {
    __block EVHomeViewController *homeController = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [homeController reloadNewsFeed];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [EVUser newsfeedWithSuccess:^(NSArray *newsfeed) {
        self.newsfeed = newsfeed;
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSError *error) {

    }];
}

#pragma mark - Button Actions

- (void)requestButtonPress:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVRequestViewController alloc] init]];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)payButtonPress:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[EVPaymentViewController_NEW alloc] init]];
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
    return [EVStoryCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    EVStory *story = [self.newsfeed objectAtIndex:indexPath.section];
    [story setLikeCount:indexPath.section];
    cell.story = story;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVStory *story = [self.newsfeed objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:[[EVTransactionDetailViewController alloc] initWithStory:story] animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
