//
//  EVFacebookInviteViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFacebookInviteViewController.h"
#import "EVFacebookInviteCell.h"
#import "EVNavigationBarButton.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "ReactiveCocoa.h"

#define SEARCH_FIELD_HEIGHT 30
#define SEARCH_FIELD_SIDE_BUFFER 10
#define SEARCH_FIELD_TEXT_BUFFER 16
#define SEARCH_BAR_HEIGHT 44

@interface EVFacebookInviteViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *fullFriendList;
@property (nonatomic, strong) NSArray *displayedFriendList;
@property (nonatomic, strong) NSMutableArray *selectedFriends;
@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *shadeView;

@end

@implementation EVFacebookInviteViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Find Friends";
        self.selectedFriends = [NSMutableArray arrayWithCapacity:0];
        
        if (FBSession.activeSession.isOpen)
            [self loadFriends];
        else
            [self openSession];
    }
    return self;
}

- (void)viewDidLoad {
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
    [self.tableView registerClass:[EVFacebookInviteCell class] forCellReuseIdentifier:@"facebookInviteCell"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVFacebookInviteCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [NSString stringWithFormat:@"facebookInviteCell-%i", (indexPath.row % 30)];
    EVFacebookInviteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
        cell = [[EVFacebookInviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.position = [self cellPositionForIndexPath:indexPath];
    
    NSDictionary *userDict = [self.displayedFriendList objectAtIndex:indexPath.row];
    [cell setName:[NSString stringWithFormat:@"%@ %@", userDict[@"first_name"], userDict[@"last_name"]] profileID:userDict[@"id"]];
    cell.handleSelection = ^(NSString *profileID) {
        [self.selectedFriends addObject:profileID];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    };
    cell.handleDeselection = ^(NSString *profileID) {
        [self.selectedFriends removeObject:profileID];
        if ([self.selectedFriends count] == 0)
            self.navigationItem.rightBarButtonItem.enabled = NO;
    };
    cell.shouldInvite = [self.selectedFriends containsObject:userDict[@"id"]];
    
    return cell;
}

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (rowCount <= 1)
        return EVGroupedTableViewCellPositionSingle;
    else {
        if (indexPath.row == 0)
            return EVGroupedTableViewCellPositionTop;
        else if (indexPath.row == rowCount - 1)
            return EVGroupedTableViewCellPositionBottom;
        else
            return EVGroupedTableViewCellPositionCenter;
    }
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
    self.displayedFriendList = [arrayToFilter filter:^BOOL(NSDictionary *userDict) {
        NSString *name = userDict[@"name"];
        return ([name.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound);
    }];
    
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

#pragma mark - Facebook Stuff

- (void)openSession {
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         if (state == FBSessionStateOpen) {
             [self loadFriends];
         } else {
             if (error) {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Error"
                                           message:error.localizedDescription
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
                 
                 [self fbResync];
                 [NSThread sleepForTimeInterval:0.5];
             } else {
                 if ([FBSession activeSession])
                     [FBSession.activeSession closeAndClearTokenInformation];
                 [self openSession];
             }
         }
     }];
}

-(void)fbResync {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    if (accountStore && accountTypeFB) {
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account = [fbAccounts objectAtIndex:0];
        if (fbAccounts && [fbAccounts count] > 0 && account){
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                
            }];
        }
    }
}

- (void)loadFriends {
    [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friends = [(NSDictionary *)result objectForKey:@"data"];
            self.fullFriendList = [friends sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1[@"first_name"] compare:obj2[@"first_name"]];
            }];
            self.displayedFriendList = self.fullFriendList;
            [self.tableView reloadData];
        }
        else
            NSLog(@"error: %@", error);
    }];
}

- (void)inviteFriends {
    [self.searchBar resignFirstResponder];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *toString = @"";
    for (NSString *profileID in self.selectedFriends) {
        toString = [toString stringByAppendingString:[NSString stringWithFormat:@"%@,", profileID]];
    }
    [params setObject:toString forKey:@"to"];

    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Try Evenly! It's a free way to transfer money between friends!"
     title:nil
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         }
     }];
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
