//
//  EVInviteContactsViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteContactsViewController.h"
#import "EVInviteContactCell.h"
#import "ABContactsHelper.h"
#import <AddressBook/AddressBook.h>
#import "EVInvite.h"

@interface EVInviteContactsViewController ()

@end

@implementation EVInviteContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.fullFriendList = [[ABContactsHelper contactsWithEmail] sortedArrayUsingComparator:^NSComparisonResult(ABContact *obj1, ABContact *obj2) {
            NSComparisonResult result = [obj1.firstname.lowercaseString compare:obj2.firstname.lowercaseString];
            if (result == NSOrderedSame)
                result = [obj1.lastname.lowercaseString compare:obj2.lastname.lowercaseString];
            return result;
        }];
        self.displayedFriendList = self.fullFriendList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVInviteContactCell class] forCellReuseIdentifier:@"contactInviteCell"];
}

#pragma mark - Invite


- (void)inviteFriends {
    [self.view findAndResignFirstResponder];
    
    NSMutableArray *emails = [NSMutableArray array];
    for (ABContact *contact in self.selectedFriends) {
        [emails addObject:[[contact emailArray] objectAtIndex:0]];
    }
    
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING INVITES..."];
    [EVInvite createWithEmails:emails
                       success:^(EVObject *object) {
                           [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                           self.selectedFriends = [NSArray array];
                           [self.tableView reloadData];
                       } failure:^(NSError *error) {
                           [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                       }];
}
#pragma mark - TableView DataSource/Delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVInviteContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contactInviteCell"];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    
    ABContact *contact = [self.displayedFriendList objectAtIndex:indexPath.row];    

    [cell setName:[EVStringUtility displayNameForContact:contact]
        profilePicture:[EVImageUtility imageForContact:contact]];
    [cell.emailLabel setText:[[contact emailArray] objectAtIndex:0]];
    cell.identifier = contact;
    cell.handleSelection = ^(ABContact *friend) {
        if (![self.selectedFriends containsObject:friend])
            self.selectedFriends = [self.selectedFriends arrayByAddingObject:friend];
    };
    cell.handleDeselection = ^(ABContact *friend) {
        if ([self.selectedFriends containsObject:friend])
            self.selectedFriends = [self.selectedFriends arrayByRemovingObject:friend];
    };
    cell.shouldInvite = [self.selectedFriends containsObject:contact];
    
    return cell;
}

#pragma mark - Utility

- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search {
    return [array filter:^BOOL(ABContact *contact) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
        return ([name.lowercaseString rangeOfString:search.lowercaseString].location != NSNotFound);
    }];
}

@end
