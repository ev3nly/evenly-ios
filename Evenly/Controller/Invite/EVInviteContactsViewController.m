//
//  EVInviteContactsViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteContactsViewController.h"
#import "EVContactInviteCell.h"
#import "ABContactsHelper.h"
#import <AddressBook/AddressBook.h>

@interface EVInviteContactsViewController ()

@end

@implementation EVInviteContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.fullFriendList = [[ABContactsHelper contactsMinusDuplicates] sortedArrayUsingComparator:^NSComparisonResult(ABContact *obj1, ABContact *obj2) {
            NSComparisonResult result = [obj1.firstname.lowercaseString compare:obj2.firstname.lowercaseString];
            if (result == NSOrderedSame)
                result = [obj1.lastname.lowercaseString compare:obj2.lastname.lowercaseString];
            return result;
        }];
        self.fullFriendList = [self.fullFriendList filter:^BOOL(ABContact *contact) {
            if (EV_IS_EMPTY_STRING(contact.firstname) && EV_IS_EMPTY_STRING(contact.lastname))
                return NO;
            return ([contact.phoneArray count] > 0);
        }];
        self.displayedFriendList = self.fullFriendList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVContactInviteCell class] forCellReuseIdentifier:@"contactInviteCell"];
}

#pragma mark - Invite

- (void)inviteFriends {
    NSLog(@"TELL SERVER TO INVITE PHONE NUMBAS WHEN THE CALL EXISTS");
}

#pragma mark - TableView DataSource/Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVContactInviteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contactInviteCell"];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    
    ABContact *contact = [self.displayedFriendList objectAtIndex:indexPath.row];    

    [cell setName:[EVStringUtility displayNameForContact:contact]
   profilePicture:[EVImageUtility imageForContact:contact]];
    cell.identifier = contact;
    cell.handleSelection = ^(ABContact *friend) {
        self.selectedFriends = [self.selectedFriends arrayByAddingObject:friend];
    };
    cell.handleDeselection = ^(ABContact *friend) {
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
