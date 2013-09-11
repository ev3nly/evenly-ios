//
//  EVGroupRequestDashboardTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestDashboardTableViewDataSource.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestTier.h"
#import "EVGroupRequestRecord.h"
#import "EVGroupRequestProgressView.h"
#import "EVDashboardSegmentedControl.h"
#import "EVDashboardTitleCell.h"
#import "EVDashboardUserCell.h"
#import "EVDashboardNoOneJoinedCell.h"
#import "EVBlueButton.h"
#import "EVWalletStamp.h"

#define TABLE_VIEW_SIDE_MARGIN ([EVUtilities userHasIOS7] ? 10 : 0)
#define GENERAL_Y_PADDING 10.0
#define GENERAL_X_MARGIN 10.0
#define GENERAL_CONTENT_WIDTH 280.0
#define REMIND_ALL_BUTTON_HEIGHT 44.0
#define NO_ONE_JOINED_ROW_HEIGHT 190.0
#define USER_ROW_HEIGHT 64.0


@interface EVGroupRequestDashboardTableViewDataSource ()

- (void)loadProgressView;
- (void)loadInviteButton;
- (void)loadRemindAllButton;

@end

@implementation EVGroupRequestDashboardTableViewDataSource

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [super init];
    if (self) {
        self.groupRequest = groupRequest;
        
        [self loadProgressView];
        [self loadInviteButton];
        [self loadRemindAllButton];
        
        [self setUpReactions];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadProgressView {
    self.progressView = [[EVGroupRequestProgressView alloc] initWithFrame:[self progressViewFrame]];
    [self.progressView setEnabled:![self noOneHasJoined]];
}

- (void)loadInviteButton {
    self.inviteButton = [[EVBlueButton alloc] initWithFrame:CGRectZero];
    [self.inviteButton setTitle:@"INVITE FRIENDS" forState:UIControlStateNormal];
}

- (void)loadRemindAllButton {
    self.remindAllButton = [[EVBlueButton alloc] initWithFrame:[self remindAllButtonFrame]];
    [self.remindAllButton setTitle:@"REMIND ALL" forState:UIControlStateNormal];
    
    UIImage *bellImage = [UIImage imageNamed:@"Request-Reminder-Bell"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bellImage];
    imageView.center = CGPointMake(2.0 * bellImage.size.width, self.remindAllButton.frame.size.height / 2.0);
    [self.remindAllButton addSubview:imageView];
}

- (void)setUpReactions {
    [RACAble(self.groupRequest.records) subscribeNext:^(NSArray *records) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Setters

- (void)setGroupRequest:(EVGroupRequest *)groupRequest {
    _groupRequest = groupRequest;
    self.displayedRecords = self.groupRequest.records;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.displayedRecords count] == 0) {
        return EVDashboardPermanentRowCOUNT + 1;
    }
    return EVDashboardPermanentRowCOUNT + [self.displayedRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    if (indexPath.row == EVDashboardPermanentRowProgress) {
        cell = [self configuredProgressCellForIndexPath:indexPath];
    }
    else {
        cell = [self configuredUserCellForIndexPath:indexPath];
    }
    cell.position = [tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (EVGroupedTableViewCell *)configuredProgressCellForIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.progressView.frame = [self progressViewFrame];
    self.progressView.centerLabel.text = [EVStringUtility amountStringForAmount:[self.groupRequest totalPaid]];
    self.progressView.rightLabel.text = [EVStringUtility amountStringForAmount:[self.groupRequest totalOwed]];
    [cell.contentView addSubview:self.progressView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (![self noOneHasJoined]) {
        self.remindAllButton.frame = [self remindAllButtonFrame];
        [cell.contentView addSubview:self.remindAllButton];
    }
    return cell;
}

- (EVGroupedTableViewCell *)configuredUserCellForIndexPath:(NSIndexPath *)indexPath {
    EVDashboardUserCell *userCell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    EVGroupRequestRecord *record = [self.displayedRecords objectAtIndex:(indexPath.row - EVDashboardPermanentRowCOUNT)];
    [userCell.nameLabel setText:record.user.name];
    [userCell.avatarView setAvatarOwner:record.user];
    [userCell.tierLabel setText:record.tier.name];
    
    if (record.completed) {
        EVWalletStamp *walletStamp = [[EVWalletStamp alloc] initWithText:@"PAID" maxWidth:50.0];
        walletStamp.fillColor = [UIColor whiteColor];
        walletStamp.strokeColor = [EVColor lightLabelColor];
        walletStamp.textColor = [EVColor lightLabelColor];
        [userCell setPaidStamp:walletStamp];
    }
    else {
        userCell.paidStamp = nil;
        [userCell.amountLabel setText:(record.tier ? [EVStringUtility amountStringForAmount:record.tier.price] : @"--")];
    }
    
    [userCell setNeedsLayout];
    userCell.selectionStyle = UITableViewCellSelectionStyleGray;
    return userCell;
}

#pragma mark - Utility

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case EVDashboardPermanentRowProgress:
            height = [EVGroupRequestProgressView height] + 2*GENERAL_Y_PADDING;
            if (![self noOneHasJoined])
                height += self.remindAllButton.frame.size.height + GENERAL_Y_PADDING;
            break;
        case EVDashboardPermanentRowCOUNT:
            if ([self noOneHasJoined])
                height = NO_ONE_JOINED_ROW_HEIGHT;
            else
                height = USER_ROW_HEIGHT;
            break;
        default:
            height = USER_ROW_HEIGHT;
            break;
    }
    return height;
}

- (EVGroupRequestRecord *)recordAtIndexPath:(NSIndexPath *)indexPath {
    if ([self noOneHasJoined])
        return nil;
    if (indexPath.row < EVDashboardPermanentRowCOUNT)
        return nil;
    if ([self.displayedRecords count] == 0)
        return nil;
    return ([self.displayedRecords objectAtIndex:(indexPath.row - EVDashboardPermanentRowCOUNT)]);
}

- (BOOL)noOneHasJoined {
    return ([self.groupRequest.records count] == 0);
}

- (void)animate {
    if (![self noOneHasJoined]) {
        [self.progressView.progressBar setProgress:[self.groupRequest progress] animated:YES];
    }
}

#pragma mark - Frames

- (CGRect)progressViewFrame {
    return CGRectMake(TABLE_VIEW_SIDE_MARGIN + GENERAL_X_MARGIN,
                      GENERAL_Y_PADDING,
                      GENERAL_CONTENT_WIDTH,
                      [EVGroupRequestProgressView height]);
}

- (CGRect)remindAllButtonFrame {
    return CGRectMake(TABLE_VIEW_SIDE_MARGIN + GENERAL_X_MARGIN,
                      CGRectGetMaxY(self.progressView.frame) + GENERAL_Y_PADDING,
                      GENERAL_CONTENT_WIDTH,
                      REMIND_ALL_BUTTON_HEIGHT);
}

@end
