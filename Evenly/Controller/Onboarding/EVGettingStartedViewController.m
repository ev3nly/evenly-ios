//
//  EVGettingStartedViewController.m
//  Evenly
//
//  Created by Justin Brunet on 8/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGettingStartedViewController.h"
#import "EVGettingStartedCell.h"

#import "UIScrollView+SVPullToRefresh.h"

#define GS_HEADER_HEIGHT 60
#define GS_TABLE_VIEW_MARGIN 10

NSString *const GettingStartedCellIdentifier = @"gettingStartedCell";

@interface EVGettingStartedViewController ()

@property (nonatomic, strong) NSArray *gettingStartedCells;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *headerTitle;
@property (nonatomic, strong) UILabel *headerSubtitle;

@end

@implementation EVGettingStartedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Getting Started";
        self.type = EVGettingStartedTypeAll;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadTableView];
    [self loadHeader];
    [self loadFooter];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
    self.header.frame = [self headerFrame];
    self.footer.frame = [self footerFrame];
    self.headerTitle.frame = [self headerTitleFrame];
    self.headerSubtitle.frame = [self headerSubtitleFrame];
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
    [self.tableView registerClass:[EVGettingStartedCell class] forCellReuseIdentifier:GettingStartedCellIdentifier];
    [self.view addSubview:self.tableView];
    
    __weak EVGettingStartedViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [EVUser meWithSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedMeNotification object:nil];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSError *error) {
            DLog(@"ERROR?! %@", error);
        } reload:YES];
    }];
}

- (void)loadHeader {
    self.header = [[UIView alloc] initWithFrame:[self headerFrame]];
    
    [self loadHeaderTitle];
    [self loadHeaderSubtitle];
    
    self.tableView.tableHeaderView = self.header;
}

- (void)loadFooter {
    self.footer = [[UIView alloc] initWithFrame:[self footerFrame]];    
    self.tableView.tableFooterView = self.footer;
}

- (void)loadHeaderTitle {
    self.headerTitle = [UILabel new];
    self.headerTitle.backgroundColor = [UIColor clearColor];
    self.headerTitle.text = @"Finish setting up your account!";
    self.headerTitle.textAlignment = NSTextAlignmentCenter;
    self.headerTitle.textColor = [EVColor darkLabelColor];
    self.headerTitle.font = [EVFont boldFontOfSize:18];
    [self.header addSubview:self.headerTitle];
}

- (void)loadHeaderSubtitle {
    self.headerSubtitle = [UILabel new];
    [self.header addSubview:self.headerSubtitle];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.gettingStartedCells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVGettingStartedCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGettingStartedCell *cell = (EVGettingStartedCell *)[tableView dequeueReusableCellWithIdentifier:GettingStartedCellIdentifier];
    cell.step = [self.gettingStartedCells[indexPath.row] intValue];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

#pragma mark - Utility

- (void)setType:(EVGettingStartedType)type {
    _type = type;
    
    self.gettingStartedCells = [self arrayForType:type];
}

- (NSArray *)arrayForType:(EVGettingStartedType)type {
    NSArray *types;
    switch (type) {
        case EVGettingStartedTypeAll:
            types = @[@(EVGettingStartedStepSignUp),
                      @(EVGettingStartedStepConfirmEmail),
                      @(EVGettingStartedStepConnectFacebook),
                      @(EVGettingStartedStepAddCard),
                      @(EVGettingStartedStepInviteFriends),
                      @(EVGettingStartedStepSendExchange),
                      @(EVGettingStartedStepAddBank)];
            break;
        case EVGettingStartedTypePayment:
            types = nil;
            break;
        case EVGettingStartedTypeRequest:
            types = nil;
            break;
        case EVGettingStartedTypeDeposit:
            types = nil;
            break;
        default:
            break;
    }
    return types;
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return self.view.bounds;
}

- (CGRect)headerFrame {
    return CGRectMake(0,
                      0,
                      self.tableView.bounds.size.width,
                      GS_HEADER_HEIGHT);
}

- (CGRect)footerFrame {
    return CGRectMake(0,
                      0,
                      self.tableView.bounds.size.width,
                      GS_HEADER_HEIGHT);
}

- (CGRect)headerTitleFrame {
    [self.headerTitle sizeToFit];
    CGRect centerFrame = EVRectCenterFrameInFrame(self.headerTitle.frame, self.header.bounds);
    centerFrame.origin.y += GS_TABLE_VIEW_MARGIN/2;
    return centerFrame;
}

- (CGRect)headerSubtitleFrame {
    return CGRectMake(0,
                      0,
                      0,
                      0);
}

@end
