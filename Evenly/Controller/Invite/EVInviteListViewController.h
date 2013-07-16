//
//  EVInviteListViewController.h
//  Evenly
//
//  Created by Justin Brunet on 7/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@interface EVInviteListViewController : EVViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *fullFriendList;
@property (nonatomic, strong) NSArray *displayedFriendList;
@property (nonatomic, strong) NSArray *selectedFriends;

- (void)loadRightButton;
- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search;

- (void)inviteFriends;

@end
