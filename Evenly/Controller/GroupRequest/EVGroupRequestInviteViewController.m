//
//  EVGroupRequestInviteViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/15/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestInviteViewController.h"
#import "EVContactInviteCell.h"
#import "ABContactsHelper.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestRecord.h"

@interface EVGroupRequestInviteViewController ()

@end

@implementation EVGroupRequestInviteViewController

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = groupRequest;
        
        // Remove any Evenly users already invited.
        for (EVGroupRequestRecord *record in self.groupRequest.records) {
            self.fullFriendList = [self.fullFriendList arrayByRemovingObject:record.user];
        }
        
        // Remove any friends whose email addresses match a SignUpUser.
        NSArray *names = [self.groupRequest.records map:^id(id object) {
            return [(EVUser *)[object user] name];
        }];
        
        NSMutableArray *friendList = [NSMutableArray arrayWithArray:self.fullFriendList];
        for (id contact in self.fullFriendList) {
            if ([contact isKindOfClass:[ABContact class]]) {
                NSString *emailAddress =[[contact emailArray] objectAtIndex:0];
                if ([names containsObject:emailAddress]) {
                    [friendList removeObject:contact];
                }
            }
        }
        self.fullFriendList = friendList;
        self.displayedFriendList = self.fullFriendList;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *filteredByEmail = [self.fullFriendList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[(ABContact *)evaluatedObject emailArray] count] > 0;
        }]];
        self.fullFriendList = [[EVCIA myConnections] arrayByAddingObjectsFromArray:filteredByEmail];
        self.displayedFriendList = self.fullFriendList;
        [self loadCancelButton];
    }
    return self;
}

- (void)loadCancelButton {
    UIImage *closeImage = [UIImage imageNamed:@"Close"];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, closeImage.size.width + 20.0, closeImage.size.height)];
    [cancelButton setImage:closeImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.showsTouchWhenHighlighted = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
}

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVContactInviteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contactInviteCell"];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    
    id contact = [self.displayedFriendList objectAtIndex:indexPath.row];
    if ([contact isKindOfClass:[ABContact class]]) {
        [cell setName:[EVStringUtility displayNameForContact:contact] profilePicture:[EVImageUtility imageForContact:contact]];
    } else if ([contact isKindOfClass:[EVUser class]]) {
        [cell setName:[contact name] profilePicture:[contact avatar]];
    }
    
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

- (void)inviteFriends {
    NSMutableArray *records = [NSMutableArray array];
    for (id contact in self.selectedFriends) {
        
        EVObject<EVExchangeable> *exchangeable;
        if ([contact isKindOfClass:[ABContact class]]) {
            NSString *emailAddress = [[contact emailArray] objectAtIndex:0];
            EVContact *toContact = [[EVContact alloc] init];
            toContact.email = emailAddress;
            toContact.name = [contact compositeName];
            exchangeable = toContact;
        } else {
            
            exchangeable = contact;
        }
        EVGroupRequestRecord *record = [[EVGroupRequestRecord alloc] initWithGroupRequest:self.groupRequest
                                                                                     user:exchangeable];
        [records addObject:record];
    }
    
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"INVITING FRIENDS..."];
    
    __weak EVGroupRequestInviteViewController *weakSelf = self;
    [self.groupRequest addRecords:records
                      withSuccess:^(NSArray *records) {
                          if (weakSelf.delegate) {
                              [weakSelf.delegate inviteViewController:weakSelf sentInvitesTo:records];
                          }
                          [[EVStatusBarManager sharedManager] setPostSuccess:^{
                              [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
                          }];
                          [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                      } failure:^(NSError *error) {
                          [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                      }];
    
    DLog(@"Record: %@", records);
    
}

- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search {
    return [array filter:^BOOL(id contact) {
        NSString *name;
        if ([contact isKindOfClass:[ABContact class]])
            name = [NSString stringWithFormat:@"%@ %@", [contact firstname], [contact lastname]];
        else
            name = [contact name];
        return ([name.lowercaseString rangeOfString:search.lowercaseString].location != NSNotFound);
    }];
}

@end
