//
//  EVFacebookInviteViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFacebookInviteViewController.h"
#import "EVFacebookInviteCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface EVFacebookInviteViewController ()

@end

@implementation EVFacebookInviteViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if (FBSession.activeSession.isOpen)
            [self loadFriends];
        else
            [self openSession];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVFacebookInviteCell class] forCellReuseIdentifier:@"facebookInviteCell"];
}

#pragma mark - TableView DataSource/Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [NSString stringWithFormat:@"facebookInviteCell-%i", (indexPath.row % 30)];
    EVFacebookInviteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
        cell = [[EVFacebookInviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    
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

#pragma mark - Utility

- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search {
    return [array filter:^BOOL(NSDictionary *userDict) {
        NSString *name = userDict[@"name"];
        return ([name.lowercaseString rangeOfString:search.lowercaseString].location != NSNotFound);
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
    [self.view findAndResignFirstResponder];
    
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

@end
