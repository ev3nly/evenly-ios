//
//  EVInviteListViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteListViewController.h"
#import "EVNavigationBarButton.h"
#import "EVGroupedTableViewCell.h"
#import "EVInviteCell.h"
#import "ReactiveCocoa.h"
#import "UIAlertView+MKBlockAdditions.h"

#define SEARCH_FIELD_HEIGHT 30
#define SEARCH_FIELD_SIDE_BUFFER 10
#define SEARCH_FIELD_TEXT_BUFFER 16
#define SEARCH_BAR_HEIGHT 44
#define SEARCH_BAR_Y_OFFSET 6

@interface EVInviteListViewController ()

@property (nonatomic, strong) UIView *incentiveLabelContainer;
@property (nonatomic, strong) UILabel *incentiveLabel;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *shadeView;

@end

@implementation EVInviteListViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Find Friends";
        self.selectedFriends = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadTableView];
    [self loadRightButton];
    [self loadSearchBar];
    [self loadIncentiveLabel];
    [self loadShadeView];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
    
    [self setUpReactions];    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.incentiveLabelContainer.frame = [self incentiveLabelContainerFrame];
    self.incentiveLabel.frame = [self incentiveLabelFrame];
    self.searchBar.frame = [self searchBarFrame];
    self.tableView.frame = [self tableViewFrame];
    self.shadeView.frame = [self shadeViewFrame];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.rowHeight = [EVInviteCell cellHeight];
    self.tableView.contentInset = UIEdgeInsetsMake(SEARCH_BAR_HEIGHT*2, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (void)loadRightButton {
    EVNavigationBarButton *button = [[EVNavigationBarButton alloc] initWithTitle:@"Invite"];
    [button addTarget:self action:@selector(inviteFriendsButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    
    self.rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:self.rightButton animated:YES];
}

- (void)loadIncentiveLabel {
    self.incentiveLabelContainer = [[UIView alloc] initWithFrame:[self incentiveLabelContainerFrame]];
    self.incentiveLabelContainer.backgroundColor = [EVColor blueColor];
    
    self.incentiveLabel = [[UILabel alloc] initWithFrame:[self incentiveLabelFrame]];
    self.incentiveLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.incentiveLabel.backgroundColor = [UIColor clearColor];
    self.incentiveLabel.textColor = [UIColor whiteColor];
    self.incentiveLabel.font = [EVFont defaultFontOfSize:15];
    self.incentiveLabel.textAlignment = NSTextAlignmentCenter;
    self.incentiveLabel.numberOfLines = 0;
    self.incentiveLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.incentiveLabelContainer addSubview:self.incentiveLabel];
    [self.view addSubview:self.incentiveLabelContainer];
    
    [self updateIncentiveString];
}

- (void)loadSearchBar {
    self.searchBar = [UISearchBar new];    
    self.searchBar.backgroundImage = [EVImageUtility imageWithColor:[EVColor blueColor]];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    [self.searchBar setPositionAdjustment:UIOffsetMake(1, 1) forSearchBarIcon:UISearchBarIconSearch];
    [self.view addSubview:self.searchBar];
}

- (void)loadShadeView {
    self.shadeView = [UIView new];
    self.shadeView.backgroundColor = [UIColor blackColor];
    self.shadeView.alpha = 0;
}

- (void)setUpReactions {
    RAC(self.navigationItem.rightBarButtonItem.enabled) = [RACSignal combineLatest:@[RACAble(self.selectedFriends)]
                                                                            reduce:^(NSArray *array) {
                                                                                [self updateIncentiveString];
                                                                                NSString *suffix = [NSString stringWithFormat:@" (%i)", [self.selectedFriends count]];
                                                                                NSString *buttonTitle = @"Invite";
                                                                                if ([self.selectedFriends count] > 0)
                                                                                    buttonTitle = [buttonTitle stringByAppendingString:suffix];
                                                                                [UIView animateWithDuration:0.3
                                                                                                 animations:^{
                                                                                                     EVNavigationBarButton *button = (EVNavigationBarButton *)self.rightButton.customView;
                                                                                                     [button setTitle:buttonTitle forState:UIControlStateNormal];
                                                                                                     [button setSize:[button frameForTitle:buttonTitle].size];
                                                                                                 }];
                                                                                return @([array count] > 0);
                                                                            }];
    
    [RACAble(self.fullFriendList) subscribeNext:^(NSArray *array) {
        [self updateIncentiveString];
    }];
}

- (void)updateIncentiveString {
    NSString *string = nil;
    switch (self.selectedFriends.count) {
        case 0:
            string = [NSString stringWithFormat:@"Earn up to %@ by inviting friends!", [EVStringUtility inviteAmountStringForNumberOfInvitees:self.fullFriendList.count]];
            break;
        case 1:
            string = [NSString stringWithFormat:@"Invite 2 more to earn $%d.", EV_DOLLARS_PER_PRIZE];
            break;
        case 2:
            string = [NSString stringWithFormat:@"Invite 1 more to earn $%d.", EV_DOLLARS_PER_PRIZE];
            break;
        default:
            string = [NSString stringWithFormat:@"When they sign up,\nyour friends get $%d, you get %@.", self.selectedFriends.count, [EVStringUtility inviteAmountStringForNumberOfInvitees:self.selectedFriends.count]];
            break;
    }
    self.incentiveLabel.text = string;
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.loading = ([self.displayedFriendList count] == 0);
    return [self.displayedFriendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; //implement in subclasses
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - SearchBar Delegate

static NSString *previousSearch = @"";

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    if (EV_IS_EMPTY_STRING(searchBar.text))
        [self showShadeView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (EV_IS_EMPTY_STRING(searchText)) {
        [self showShadeView];
        self.displayedFriendList = self.fullFriendList;
        return;
    }
    else if (self.shadeView.superview)
        [self hideShadeView];
    
    NSArray *arrayToFilter = ([searchText rangeOfString:previousSearch].location != NSNotFound) ? self.displayedFriendList : self.fullFriendList;
    self.displayedFriendList = [self filterArray:arrayToFilter forSearch:searchText];
    
    previousSearch = searchText;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self hideShadeView];
    previousSearch = @"";
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    self.displayedFriendList = self.fullFriendList;
    [self searchBarTextDidEndEditing:searchBar];
    [self.view findAndResignFirstResponder];
}

- (void)showShadeView {
    [self.view addSubview:self.shadeView];
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.shadeView.alpha = 0.7;
                     }];
}

- (void)hideShadeView {
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.shadeView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.shadeView removeFromSuperview];
                     }];
}

#pragma mark - Invite

- (void)inviteFriendsButtonPress:(id)sender {
    [self inviteFriends];
}

- (void)inviteFriends {
    //implement in subclass
}

- (void)backButtonPress:(id)sender {
    if ([self.selectedFriends count] == 0) {
        [super backButtonPress:sender];
        return;
    }
    NSString *friendString = [self.selectedFriends count] == 1 ? @"friend" : @"friends";
    [[UIAlertView alertViewWithTitle:@"Oops!"
                             message:[NSString stringWithFormat:@"Would you like to invite your %@ before you leave?", friendString]
                   cancelButtonTitle:@"Don't Invite"
                   otherButtonTitles:@[@"Invite"]
                           onDismiss:^(int buttonIndex) {
                               [self inviteFriends];
                           } onCancel:^{
                               [super backButtonPress:sender];
                           }] show];
}

#pragma mark - Utility

- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search {
    return array;//implement in subclass
}

#pragma mark - Setters

- (void)setDisplayedFriendList:(NSArray *)displayedFriendList {
    _displayedFriendList = displayedFriendList;
    
    [self.tableView reloadData];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return self.view.bounds;
    return CGRectMake(0,
                      CGRectGetMaxY(self.searchBar.frame),
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - self.searchBar.bounds.size.height);
}

- (CGRect)incentiveLabelContainerFrame {
    return CGRectMake(0,
                      [self totalBarHeight],
                      self.view.bounds.size.width,
                      SEARCH_BAR_HEIGHT);
}

- (CGRect)incentiveLabelFrame {
    return self.incentiveLabelContainer.bounds;
}

- (CGRect)searchBarFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.incentiveLabelContainer.frame) - SEARCH_BAR_Y_OFFSET,
                      self.view.bounds.size.width,
                      SEARCH_BAR_HEIGHT);
}

- (CGRect)shadeViewFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.searchBar.frame),
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - CGRectGetMaxY(self.searchBar.frame));
}

@end
