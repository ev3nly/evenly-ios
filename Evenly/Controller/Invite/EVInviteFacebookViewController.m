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

@interface EVInviteFacebookViewController ()

@end

@implementation EVInviteFacebookViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [EVFacebookManager loadFriendsWithCompletion:^(NSArray *friends) {
            self.fullFriendList = [friends sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSComparisonResult result = [obj1[@"first_name"] compare:obj2[@"first_name"]];
                if (result == NSOrderedSame)
                    result = [obj1[@"last_name"] compare:obj2[@"last_name"]];
                return result;
            }];
            self.displayedFriendList = self.fullFriendList;
            [self.tableView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVInviteFacebookCell class] forCellReuseIdentifier:@"facebookInviteCell"];
}

#pragma mark - TableView DataSource/Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [NSString stringWithFormat:@"facebookInviteCell-%i", (indexPath.row % 30)];
    EVInviteFacebookCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
        cell = [[EVInviteFacebookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    
    NSDictionary *userDict = [self.displayedFriendList objectAtIndex:indexPath.row];
    [cell setName:[NSString stringWithFormat:@"%@ %@", userDict[@"first_name"], userDict[@"last_name"]] profileID:userDict[@"id"]];
    cell.handleSelection = ^(NSString *profileID) {
        if (![self.selectedFriends containsObject:profileID])
            self.selectedFriends = [self.selectedFriends arrayByAddingObject:profileID];
    };
    cell.handleDeselection = ^(NSString *profileID) {
        if ([self.selectedFriends containsObject:profileID])
            self.selectedFriends = [self.selectedFriends arrayByRemovingObject:profileID];
    };
    cell.shouldInvite = [self.selectedFriends containsObject:userDict[@"id"]];
    
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
             self.selectedFriends = [NSArray array];
             [self.tableView reloadData];
         }
     }];
}

@end
