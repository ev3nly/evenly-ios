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

#define GENERAL_Y_PADDING 10.0
#define GENERAL_X_MARGIN 10.0
#define GENERAL_CONTENT_WIDTH 275.0
#define REMIND_ALL_BUTTON_HEIGHT 44.0
#define SEGMENTED_CONTROL_HEIGHT 40.0
#define NO_ONE_JOINED_ROW_HEIGHT 190.0
#define USER_ROW_HEIGHT 64.0


@interface EVGroupRequestDashboardTableViewDataSource ()

- (void)loadSegmentedControl;
- (void)loadProgressView;
- (void)loadInviteButton;
- (void)loadRemindAllButton;

@end

@implementation EVGroupRequestDashboardTableViewDataSource

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [super init];
    if (self) {
        self.groupRequest = groupRequest;
        
        [self loadSegmentedControl];
        [self loadProgressView];
        [self loadInviteButton];
        [self loadRemindAllButton];
        
        [self setUpReactions];
        
    }
    return self;
}

- (void)setGroupRequest:(EVGroupRequest *)groupRequest {
    _groupRequest = groupRequest;
    self.displayedRecords = self.groupRequest.records;
}

- (void)loadSegmentedControl {
    self.segmentedControl = [[EVDashboardSegmentedControl alloc] initWithItems:@[ @"All", @"Paying", @"Paid" ]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)loadProgressView {
    self.progressView = [[EVGroupRequestProgressView alloc] initWithFrame:CGRectMake(0,
                                                                                     0,
                                                                                     GENERAL_CONTENT_WIDTH,
                                                                                     [EVGroupRequestProgressView height])];
    [self.progressView setEnabled:![self noOneHasJoined]];
}

- (void)loadInviteButton {
    self.inviteButton = [[EVBlueButton alloc] initWithFrame:CGRectZero];
    [self.inviteButton setTitle:@"INVITE FRIENDS" forState:UIControlStateNormal];
}

- (void)loadRemindAllButton {
    self.remindAllButton = [[EVBlueButton alloc] initWithFrame:CGRectMake(GENERAL_X_MARGIN,
                                                                          CGRectGetMaxY(self.progressView.frame) + GENERAL_Y_PADDING,
                                                                          GENERAL_CONTENT_WIDTH,
                                                                          REMIND_ALL_BUTTON_HEIGHT)];
    [self.remindAllButton setTitle:@"REMIND ALL" forState:UIControlStateNormal];
    
    UIImage *bellImage = [UIImage imageNamed:@"Request-Reminder-Bell"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bellImage];
    imageView.center = CGPointMake(2.0 * bellImage.size.width, self.remindAllButton.frame.size.height / 2.0);
    [self.remindAllButton addSubview:imageView];
}

- (void)setUpReactions {
    [RACAble(self.groupRequest.records) subscribeNext:^(NSArray *records) {
        [self.tableView reloadData];
    }];
}

- (BOOL)noOneHasJoined {
    return ([self.groupRequest.records count] == 0);
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
    if (indexPath.row == EVDashboardPermanentRowTitle)
    {
        EVDashboardTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        [titleCell.titleLabel setText:self.groupRequest.title];
        [titleCell.memoLabel setText:self.groupRequest.memo];
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = titleCell;
    }
    else if (indexPath.row == EVDashboardPermanentRowProgress)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setPosition:EVGroupedTableViewCellPositionCenter];
        [self.progressView setFrame:CGRectMake(GENERAL_X_MARGIN,
                                               GENERAL_Y_PADDING,
                                               cell.contentView.frame.size.width - 2*GENERAL_X_MARGIN,
                                               self.progressView.frame.size.height)];
        self.progressView.centerLabel.text = [EVStringUtility amountStringForAmount:[self.groupRequest totalPaid]];
        self.progressView.rightLabel.text = [EVStringUtility amountStringForAmount:[self.groupRequest totalOwed]];
        [cell.contentView addSubview:self.progressView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (![self noOneHasJoined])
        {
            [self.remindAllButton setFrame:CGRectMake(self.remindAllButton.frame.origin.x,
                                                      CGRectGetMaxY(self.progressView.frame) + GENERAL_Y_PADDING,
                                                      self.remindAllButton.frame.size.width,
                                                      self.remindAllButton.frame.size.height)];
            [cell.contentView addSubview:self.remindAllButton];
        }
    }
    else if (indexPath.row == EVDashboardPermanentRowSegmentedControl)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setPosition:EVGroupedTableViewCellPositionCenter];
        [self.segmentedControl setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, SEGMENTED_CONTROL_HEIGHT)];
        [cell.contentView addSubview:self.segmentedControl];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        if ([self noOneHasJoined])
        {
            EVDashboardNoOneJoinedCell *noOneJoinedCell = [tableView dequeueReusableCellWithIdentifier:@"noOneJoinedCell" forIndexPath:indexPath];
            noOneJoinedCell.inviteButton = self.inviteButton;
            cell = noOneJoinedCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if ([self.displayedRecords count] > 0)
        {
            EVDashboardUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
            EVGroupRequestRecord *record = [self.displayedRecords objectAtIndex:(indexPath.row - EVDashboardPermanentRowCOUNT)];
            /**
             * BE MY BABYMAMA, BE A MILLIONAIRE
             */
            [userCell.nameLabel setText:@"Joseph H. Betherontonson"];
//            [userCell.nameLabel setText:record.user.name];
            [userCell.avatarView setAvatarOwner:record.user];
            [userCell.tierLabel setText:record.tier.name];
            if (record.tier == nil) {
                
                userCell.paidStamp = nil;
                userCell.noTierLabel = [EVDashboardUserCell configuredNoTierLabel];
            } else if (record.completed) {
                
                userCell.noTierLabel = nil;
                EVWalletStamp *walletStamp = [[EVWalletStamp alloc] initWithText:@"PAID" maxWidth:50.0];
                walletStamp.fillColor = [UIColor whiteColor];
                walletStamp.strokeColor = [EVColor lightLabelColor];
                walletStamp.textColor = [EVColor lightLabelColor];
                [userCell setPaidStamp:walletStamp];
            }
            else {
                userCell.paidStamp = nil;
                userCell.noTierLabel = nil;
                [userCell.owesAmountLabel setText:(record.tier ? [EVStringUtility amountStringForAmount:record.tier.price] : @"--")];
                [userCell.paidAmountLabel setText:[EVStringUtility amountStringForAmount:record.amountPaid]];
            }
            
            if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section])
                userCell.position = EVGroupedTableViewCellPositionBottom;
            else
                userCell.position = EVGroupedTableViewCellPositionCenter;
            [userCell setNeedsLayout];
            cell = userCell;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
        }
    }
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case EVDashboardPermanentRowTitle:
            height = [EVDashboardTitleCell heightWithTitle:self.groupRequest.title memo:self.groupRequest.memo];
            break;
        case EVDashboardPermanentRowProgress:
            height = [EVGroupRequestProgressView height] + 2*GENERAL_Y_PADDING;
            if (![self noOneHasJoined])
                height += self.remindAllButton.frame.size.height + GENERAL_Y_PADDING;
            break;
        case EVDashboardPermanentRowSegmentedControl:
            height = SEGMENTED_CONTROL_HEIGHT;
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

- (void)animate {
    if (![self noOneHasJoined]) {
        [self.progressView.progressBar setProgress:[self.groupRequest progress] animated:YES];
    }

}

- (void)segmentedControlChanged:(EVSegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case EVDashboardSegmentAll:
            self.displayedRecords = self.groupRequest.records;
            break;
        case EVDashboardSegmentPaying:
            self.displayedRecords = [self.groupRequest.records filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"completed == FALSE"]];
            break;
        case EVDashboardSegmentPaid:
            self.displayedRecords = [self.groupRequest.records filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"completed == TRUE"]];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

@end
