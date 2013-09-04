//
//  EVFacebookInviteViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteFacebookViewController.h"
#import "EVInviteFacebookCell.h"
#import "EVFacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EVInvite.h"

#define SECTION_HEADER_HEIGHT 30
#define SECTION_HEADER_X_MARGIN 20
#define SECTION_HEADER_Y_INSET 10
#define SECTION_HEADER_LABEL_HEIGHT 16

@interface EVInviteFacebookViewController ()

@property (nonatomic, strong) NSArray *closeFriends;

@end

@implementation EVInviteFacebookViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVInviteFacebookCell class] forCellReuseIdentifier:@"facebookInviteCell"];
    [self loadFriends];
}

- (void)loadFriends {
    self.tableView.loading = YES;
    [EVFacebookManager loadFriendsWithCompletion:^(NSArray *friends) {
        [EVCIA me].facebookFriendCount = [friends count];
        [[NSUserDefaults standardUserDefaults] setInteger:[friends count] forKey:EVUserFacebookFriendCountKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.fullFriendList = [friends sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result = [obj1[@"first_name"] compare:obj2[@"first_name"]];
            if (result == NSOrderedSame)
                result = [obj1[@"last_name"] compare:obj2[@"last_name"]];
            return result;
        }];
        [EVFacebookManager loadCloseFriendsWithCompletion:^(NSArray *closeFriends) {
            self.closeFriends = [closeFriends sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSComparisonResult result = [obj1[@"name"] compare:obj2[@"name"]];
                return result;
            }];
            self.tableView.loading = NO;
            self.displayedFriendList = self.fullFriendList;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            DLog(@"Error: %@", error);
            self.tableView.loading = NO;
            self.displayedFriendList = self.fullFriendList;
            [self.tableView reloadData]; // reload the table anyway because the full friend list came in
        }];
    } failure:^(NSError *error) {
        self.tableView.loading = NO;
    }];
}

- (BOOL)shouldShowCloseFriends {
    return ([self.displayedFriendList isEqualToArray:self.fullFriendList] && (self.closeFriends && [self.closeFriends count]));
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self shouldShowCloseFriends])
        return 2;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self shouldShowCloseFriends] && section == 0)
        return self.closeFriends.count;
    else
        return self.displayedFriendList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.loading)
        return nil;
    
    if ([self shouldShowCloseFriends] && section == 0)
        return @"Close Friends";
    else
        return @"Friends";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.loading)
        return nil;
    
    NSString *string = [self tableView:tableView titleForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SECTION_HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SECTION_HEADER_X_MARGIN,
                                                               SECTION_HEADER_Y_INSET,
                                                               self.view.frame.size.width - 2*SECTION_HEADER_X_MARGIN,
                                                               SECTION_HEADER_LABEL_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [EVColor darkColor];
    label.font = [EVFont blackFontOfSize:15];
    label.text = string;
    [view addSubview:label];
    return view;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *userDict = nil;
    if ([self shouldShowCloseFriends] && indexPath.section == 0)
        userDict = [self.closeFriends objectAtIndex:indexPath.row];
    else
        userDict = [self.displayedFriendList objectAtIndex:indexPath.row];

    NSString *reuseIdentifier = [NSString stringWithFormat:@"facebookInviteCell-%i", (indexPath.row % 30)];
    EVInviteFacebookCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
        cell = [[EVInviteFacebookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    [cell setName:userDict[@"name"] profileID:userDict[@"id"]];
    cell.handleSelection = ^(NSString *profileID) {
        if (![self.selectedFriends containsObject:profileID])
            self.selectedFriends = [self.selectedFriends arrayByAddingObject:profileID];
    };
    cell.handleDeselection = ^(NSString *profileID) {
        if ([self.selectedFriends containsObject:profileID])
            self.selectedFriends = [self.selectedFriends arrayByRemovingObject:profileID];
    };
    cell.shouldInvite = [self.selectedFriends containsObject:userDict[@"id"]];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

#pragma mark - Utility

- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search {
    return [array filter:^BOOL(NSDictionary *userDict) {
        NSString *name = userDict[@"name"];
        return ([name.lowercaseString rangeOfString:search.lowercaseString].location != NSNotFound);
    }];
}

#pragma mark - Facebook

- (void)inviteFriends {
    [self.view findAndResignFirstResponder];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *toString = @"";
    for (NSString *profileID in self.selectedFriends) {
        toString = [toString stringByAppendingString:[NSString stringWithFormat:@"%@,", profileID]];
    }
    [params setObject:toString forKey:@"to"];

    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Evenly is a free and easy way to share any expense"
     title:nil
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         }
         if ([[resultURL relativeString] containsString:@"request="]) {
             [EVInvite createWithFacebookIDs:self.selectedFriends
                                     success:^(EVObject *object) {
                                         DLog(@"Success: %@", object);
                                     } failure:^(NSError *error) {
                                         DLog(@"Failure: %@", error);
                                     }];             
             self.selectedFriends = [NSArray array];
             [self.tableView reloadData];
         }
     }];
}

@end
