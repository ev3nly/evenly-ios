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

@interface EVFacebookInviteViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *selectedFriends;
@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *searchBackground;
@property (nonatomic, strong) UIView *searchOval;
@property (nonatomic, strong) UITextField *searchField;
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
//    [self loadSearchBackground];
//    [self loadSearchOval];
//    [self loadSearchField];
    [self loadShadeView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.searchBackground.frame = [self searchBackgroundFrame];
    self.searchBar.frame = [self searchBackgroundFrame];
    self.searchOval.frame = [self searchOvalFrame];
    self.searchField.frame = [self searchFieldFrame];
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
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
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
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)loadSearchBackground {
    self.searchBackground = [UIView new];
    self.searchBackground.backgroundColor = EV_RGB_COLOR(0, 114, 208);// [EVColor blueColor];
    [self.view addSubview:self.searchBackground];
}

- (void)loadSearchOval {
    self.searchOval = [UIView new];
    self.searchOval.backgroundColor = [EVColor lightColor];
    self.searchOval.layer.cornerRadius = SEARCH_FIELD_HEIGHT/2.0;
    [self.searchBackground addSubview:self.searchOval];
}

- (void)loadSearchField {
    self.searchField = [UITextField new];
    self.searchField.backgroundColor = [UIColor clearColor];
    self.searchField.text = @"";
    self.searchField.textColor = [EVColor darkLabelColor];
    self.searchField.font = [EVFont boldFontOfSize:15];
    self.searchField.delegate = self;
    self.searchField.returnKeyType = UIReturnKeyDone;
    self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchField.placeholder = @"Search";
    [self.searchOval addSubview:self.searchField];
}

- (void)loadShadeView {
    self.shadeView = [UIView new];
    self.shadeView.backgroundColor = [UIColor blackColor];
    self.shadeView.alpha = 0;
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
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

    NSDictionary *userDict = [self.friends objectAtIndex:indexPath.row];
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

#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
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
             }
             if ([FBSession activeSession])
                 [FBSession.activeSession closeAndClearTokenInformation];
             [self openSession];
         }
     }];
}

- (void)loadFriends {
    [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            self.friends = [(NSDictionary *)result objectForKey:@"data"];
            self.friends = [self.friends sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1[@"first_name"] compare:obj2[@"first_name"]];
            }];
            [self.tableView reloadData];
        }
        else
            NSLog(@"error: %@", error);
    }];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.searchBackground.frame),
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - self.searchBackground.bounds.size.height);
}

- (CGRect)searchBackgroundFrame {
    return CGRectMake(0,
                      0,
                      self.view.bounds.size.width,
                      44);
}

- (CGRect)searchOvalFrame {
    return CGRectMake(SEARCH_FIELD_SIDE_BUFFER,
                      self.searchBackground.bounds.size.height/2 - SEARCH_FIELD_HEIGHT/2,
                      self.searchBackground.bounds.size.width - SEARCH_FIELD_SIDE_BUFFER*2,
                      SEARCH_FIELD_HEIGHT);
}

- (CGRect)searchFieldFrame {
    return CGRectMake(SEARCH_FIELD_TEXT_BUFFER,
                      1,
                      self.searchOval.bounds.size.width - SEARCH_FIELD_TEXT_BUFFER*2,
                      self.searchOval.bounds.size.height);
}

- (CGRect)shadeViewFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.searchBackground.frame),
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - CGRectGetMaxY(self.searchBackground.frame));
}

@end
