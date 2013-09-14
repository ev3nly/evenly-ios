//
//  EVGettingStartedViewController.m
//  Evenly
//
//  Created by Justin Brunet on 8/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGettingStartedViewController.h"
#import "EVGettingStartedCell.h"
#import "EVFacebookManager.h"
#import "EVCardsViewController.h"
#import "EVInviteViewController.h"
#import "EVInviteFacebookViewController.h"
#import "EVBanksViewController.h"
#import "EVPaymentViewController.h"
#import "EVRequestViewController.h"
#import "EVNavigationManager.h"

#import "UIScrollView+SVPullToRefresh.h"

#define GS_HEADER_HEIGHT 40
#define GS_FOOTER_HEIGHT 54
#define GS_TABLE_VIEW_MARGIN 10

NSString *const GettingStartedCellIdentifier = @"gettingStartedCell";

@interface EVGettingStartedViewController ()

@property (nonatomic, strong) NSArray *gettingStartedCells;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *headerTitle;
@property (nonatomic, strong) UIButton *footerButton;

@end

@implementation EVGettingStartedViewController

- (id)initWithType:(EVGettingStartedType)type {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = @"Getting Started";
        self.type = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadedMe) name:EVCIAUpdatedMeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadTableView];
    [self loadHeader];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
    self.header.frame = [self headerFrame];
    self.footer.frame = [self footerFrame];
    self.headerTitle.frame = [self headerTitleFrame];
    self.footerButton.frame = [self footerButtonFrame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshSelf];
    [EVUser meWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedMeNotification object:nil];
    } failure:^(NSError *error) {
        DLog(@"ERROR?! %@", error);
    } reload:YES];
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
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSError *error) {
            DLog(@"ERROR?! %@", error);
        } reload:YES];
    }];
    self.tableView.pullToRefreshView.originalTopInset = [self totalBarHeight];
}

- (void)loadHeader {
    self.header = [[UIView alloc] initWithFrame:[self headerFrame]];
    
    [self loadHeaderTitle];
    
    self.tableView.tableHeaderView = self.header;
}

- (void)loadFooter {
    self.footer = [[UIView alloc] initWithFrame:[self footerFrame]];    
    self.tableView.tableFooterView = self.footer;
    [self loadFooterButton];
}

- (void)loadHeaderTitle {
    self.headerTitle = [UILabel new];
    self.headerTitle.backgroundColor = [UIColor clearColor];
    self.headerTitle.text = [self headerString];
    self.headerTitle.textAlignment = NSTextAlignmentCenter;
    self.headerTitle.textColor = [EVColor darkLabelColor];
    self.headerTitle.font = [EVFont boldFontOfSize:17];
    [self.header addSubview:self.headerTitle];
}

- (void)loadFooterButton {
    self.footerButton = [UIButton new];
    self.footerButton.frame = [self footerButtonFrame];
    [self.footerButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.footerButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.footerButton addTarget:self action:@selector(footerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.footerButton setTitle:[self footerButtonString] forState:UIControlStateNormal];
    [self.footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.footer addSubview:self.footerButton];
}

#pragma mark - Button Handling

- (void)footerButtonTapped {
    self.controllerToShow.shouldDismissGrandparent = YES;
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:self.controllerToShow];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Setters

- (void)setType:(EVGettingStartedType)type {
    _type = type;
    
    self.gettingStartedCells = [self gettingStartedSteps];
    self.headerTitle.text = [self headerString];
}

#pragma mark - Steps

- (NSArray *)gettingStartedSteps {
    NSArray *types;
    switch (self.type) {
        case EVGettingStartedTypeAll:
            types = @[@(EVGettingStartedStepSignUp),
                      @(EVGettingStartedStepConnectFacebook),
                      @(EVGettingStartedStepConfirmEmail),
                      @(EVGettingStartedStepAddCard),
                      @(EVGettingStartedStepInviteFriends),
                      @(EVGettingStartedStepSendPayment),
                      @(EVGettingStartedStepSendRequest),
                      @(EVGettingStartedStepAddBank)];
            break;
        case EVGettingStartedTypePayment:
            types = @[@(EVGettingStartedStepSignUp),
                      @(EVGettingStartedStepConfirmEmail),
                      @(EVGettingStartedStepAddCard)];
            break;
        case EVGettingStartedTypeRequest:
            types = @[@(EVGettingStartedStepSignUp),
                      @(EVGettingStartedStepConfirmEmail)];
            break;
        case EVGettingStartedTypeDeposit:
            types = @[@(EVGettingStartedStepSignUp),
                      @(EVGettingStartedStepConfirmEmail),
                      @(EVGettingStartedStepAddBank)];
            break;
        default:
            break;
    }
    return types;
}

- (BOOL)completedStep:(EVGettingStartedStep)step {
    switch (step) {
        case EVGettingStartedStepSignUp:
            return YES;
        case EVGettingStartedStepConfirmEmail:
            return ![EVCIA me].isUnconfirmed;
        case EVGettingStartedStepConnectFacebook:
            return [EVCIA me].facebookConnected;
        case EVGettingStartedStepAddCard:
            return [EVCIA me].hasAddedCard;
        case EVGettingStartedStepInviteFriends:
            return [EVCIA me].hasInvitedFriends;
        case EVGettingStartedStepSendPayment:
            return [EVCIA me].hasSentPayment;
        case EVGettingStartedStepSendRequest:
            return [EVCIA me].hasSentRequest;
        case EVGettingStartedStepAddBank:
            return [EVCIA me].hasAddedBank;
        default:
            return NO;
    }
}

- (void)refreshSelf {
    BOOL finishedAllSteps = YES;
    for (NSNumber *numberStep in self.gettingStartedCells) {
        EVGettingStartedStep step = [numberStep intValue];
        if (![self completedStep:step]) {
            finishedAllSteps = NO;
            break;
        }
    }
    [self.tableView reloadData];
    if (finishedAllSteps) {
        if (self.type != EVGettingStartedTypeAll) {
            if (self.type == EVGettingStartedTypeDeposit && [[EVCIA sharedInstance].me.balance isEqualToNumber:[NSDecimalNumber zero]])
                return;
            [self loadFooter];
        }
        else {
            [[EVNavigationManager sharedManager].walletViewController.tableView reloadData];
            [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:nil];
            self.headerTitle.text = @"You made it!";
        }
    }
}

- (void)reloadedMe {
    [self refreshSelf];
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
    cell.completed = [self completedStep:cell.step];
    cell.action = ^(EVGettingStartedStep step) {
        [self performActionForStep:step];
    };
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

#pragma mark - Actions

- (void)performActionForStep:(EVGettingStartedStep)step {    
    switch (step) {
        case EVGettingStartedStepConfirmEmail:
            [self sendConfirmationEmail];
            break;
        case EVGettingStartedStepConnectFacebook:
            [self connectFacebook];
            break;
        case EVGettingStartedStepAddCard:
            [self addCard];
            break;
        case EVGettingStartedStepInviteFriends:
            [self inviteFriends];
            break;
        case EVGettingStartedStepSendPayment:
            [self sendPayment];
            break;
        case EVGettingStartedStepSendRequest:
            [self sendRequest];
            break;
        case EVGettingStartedStepAddBank:
            [self addBank];
            break;
        default:
            break;
    }
}

- (void)sendConfirmationEmail {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"RESENDING..."];
    [EVUser sendConfirmationEmailWithSuccess:^{
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

- (void)connectFacebook {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CONNECTING..."];
    [EVFacebookManager loadMeWithCompletion:^(NSDictionary *userDict){
        [EVUser updateMeWithFacebookToken:[EVFacebookManager sharedManager].tokenData.accessToken
                               facebookID:[EVFacebookManager sharedManager].facebookID
                                  success:^{
                                      [[EVCIA me] setFacebookConnected:YES];
                                      [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                                      [self.tableView reloadData];
                                  } failure:^(NSError *error) {
                                      [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                                  }];
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

- (void)addCard {
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[EVCardsViewController new]];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)inviteFriends {
    EVInviteViewController *inviteController = [EVInviteViewController new];
    inviteController.canDismissManually = YES;
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:inviteController];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)sendPayment {
    if ([EVCIA me].isUnconfirmed) {
        [[UIAlertView alertViewWithTitle:@"Whoops!" message:@"You need to confirm your email before you can send a payment." cancelButtonTitle:@"OK"] show];
        return;
    } else if (![EVCIA me].hasAddedCard) {
        [[UIAlertView alertViewWithTitle:@"Whoops!" message:@"You need to add a card before you can send a payment." cancelButtonTitle:@"OK"] show];
        return;
    }
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[EVPaymentViewController new]];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)sendRequest {
    if ([EVCIA me].isUnconfirmed) {
        [[UIAlertView alertViewWithTitle:@"Whoops!" message:@"You need to confirm your email before you can send a request." cancelButtonTitle:@"OK"] show];
        return;
    }
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[EVRequestViewController new]];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)addBank {
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[EVBanksViewController new]];
    [self presentViewController:navController animated:YES completion:NULL];
}

#pragma mark - Strings

- (NSString *)headerString {
    switch (self.type) {
        case EVGettingStartedTypeAll:
            return @"You're almost there!";
            break;
        case EVGettingStartedTypePayment:
            return @"You're almost ready to pay!";
            break;
        case EVGettingStartedTypeRequest:
            return @"You're almost ready to request!";
            break;
        case EVGettingStartedTypeDeposit:
            return @"You're almost ready to deposit!";
            break;
        default:
            return @"";
    }
}

- (NSString *)footerButtonString {
    switch (self.type) {
        case EVGettingStartedTypeAll:
            return @"";
            break;
        case EVGettingStartedTypePayment:
            return @"Pay your friend!";
            break;
        case EVGettingStartedTypeRequest:
            return @"Send your request!";
            break;
        case EVGettingStartedTypeDeposit:
            return @"Deposit!";
            break;
        default:
            return @"";
    }
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    return tableFrame;
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
                      GS_FOOTER_HEIGHT);
}

- (CGRect)headerTitleFrame {
    [self.headerTitle sizeToFit];
    CGRect centerFrame = EVRectCenterFrameInFrame(self.headerTitle.frame, self.header.bounds);
    centerFrame.origin.y += GS_TABLE_VIEW_MARGIN/2;
    return centerFrame;
}

- (CGRect)footerButtonFrame {
    return CGRectMake(GS_TABLE_VIEW_MARGIN,
                      GS_TABLE_VIEW_MARGIN,
                      self.footer.bounds.size.width - GS_TABLE_VIEW_MARGIN*2,
                      self.footer.bounds.size.height - GS_TABLE_VIEW_MARGIN);
}

@end
