//
//  EVWalletNotificationViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 8/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletNotificationViewController.h"
#import "EVWalletNotificationDetailCell.h"

@interface EVWalletNotificationViewController ()

@end

@implementation EVWalletNotificationViewController


- (id)initWithWalletNotification:(EVWalletNotification *)walletNotification {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.walletNotification = walletNotification;
        self.title = @"Notification";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVWalletNotificationDetailCell class] forCellReuseIdentifier:@"EVWalletNotificationDetailCell"];
    [self.view addSubview:self.tableView];    
}


- (void)sendConfirmationEmail:(id)sender {
    // TODO:
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UNCONFIRMED_NOTIFICATION_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVWalletNotificationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVWalletNotificationDetailCell" forIndexPath:indexPath];
    cell.notificationController = self;
    [cell.storyLabel setAttributedText:[self.walletNotification attributedText]];
    [cell.avatarView setImage:[self.walletNotification avatar]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
