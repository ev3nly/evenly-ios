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
#import <QuartzCore/QuartzCore.h>
#import "ReactiveCocoa.h"

#define SEARCH_FIELD_HEIGHT 30
#define SEARCH_FIELD_SIDE_BUFFER 10
#define SEARCH_FIELD_TEXT_BUFFER 16
#define SEARCH_BAR_HEIGHT 44

@interface EVInviteListViewController ()

@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *shadeView;


@end

@implementation EVInviteListViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Find Friends";
        self.selectedFriends = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadTableView];
    [self loadRightButton];
    [self loadSearchBar];
    [self loadShadeView];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
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
    [self.view addSubview:self.tableView];
}

- (void)loadRightButton {
    EVNavigationBarButton *button = [[EVNavigationBarButton alloc] initWithTitle:@"Invite"];
    [button addTarget:self action:@selector(inviteFriends) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    self.rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:self.rightButton animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)loadSearchBar {
    self.searchBar = [UISearchBar new];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    backgroundView.backgroundColor = EV_RGB_COLOR(0, 114, 208);
    
    UIGraphicsBeginImageContext(backgroundView.bounds.size);
    [backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.searchBar.backgroundImage = backgroundImage;
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

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayedFriendList count];
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

- (void)inviteFriends {
    //implement in subclass
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
    return CGRectMake(0,
                      CGRectGetMaxY(self.searchBar.frame),
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - self.searchBar.bounds.size.height);
}

- (CGRect)searchBarFrame {
    return CGRectMake(0,
                      0,
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
