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

@implementation EVGroupRequestDashboardTableViewDataSource

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [super init];
    if (self) {
        self.groupRequest = groupRequest;
        self.displayedRecords = self.groupRequest.records;
        
        self.segmentedControl = [[EVDashboardSegmentedControl alloc] initWithItems:@[ @"All", @"Paying", @"Paid" ]];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
        self.progressView = [[EVGroupRequestProgressView alloc] initWithFrame:CGRectMake(0, 0, 275, [EVGroupRequestProgressView height])];
        
        self.inviteButton = [[EVBlueButton alloc] initWithFrame:CGRectZero];
        [self.inviteButton setTitle:@"INVITE FRIENDS" forState:UIControlStateNormal];
    }
    return self;
}


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
        cell = titleCell;
    }
    else if (indexPath.row == EVDashboardPermanentRowProgress)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setPosition:EVGroupedTableViewCellPositionCenter];
        [self.progressView setFrame:CGRectMake(10, 10, cell.contentView.frame.size.width - 20.0, self.progressView.frame.size.height)];
        [cell.contentView addSubview:self.progressView];
    }
    else if (indexPath.row == EVDashboardPermanentRowSegmentedControl)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setPosition:EVGroupedTableViewCellPositionCenter];
        [self.segmentedControl setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 40.0)];
        [cell.contentView addSubview:self.segmentedControl];
    }
    else
    {
        if ([self.groupRequest.records count] == 0)
        {
            EVDashboardNoOneJoinedCell *noOneJoinedCell = [tableView dequeueReusableCellWithIdentifier:@"noOneJoinedCell" forIndexPath:indexPath];
            noOneJoinedCell.inviteButton = self.inviteButton;
            cell = noOneJoinedCell;
        }
        else if ([self.displayedRecords count] > 0)
        {
            EVDashboardUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
            EVGroupRequestRecord *record = [self.displayedRecords objectAtIndex:(indexPath.row - EVDashboardPermanentRowCOUNT)];
            [userCell.nameLabel setText:record.user.name];
            [userCell.avatarView setAvatarOwner:record.user];
            [userCell.tierLabel setText:record.tier.name];
            
            if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section])
                userCell.position = EVGroupedTableViewCellPositionBottom;
            else
                userCell.position = EVGroupedTableViewCellPositionCenter;
            cell = userCell;
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
        }
    }
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVDashboardPermanentRowTitle)
    {
        CGFloat height = [EVDashboardTitleCell heightWithTitle:self.groupRequest.title memo:self.groupRequest.memo];
        return height;
    }
    else if (indexPath.row == EVDashboardPermanentRowSegmentedControl)
    {
        return 40.0;
    }
    else if (indexPath.row == EVDashboardPermanentRowProgress)
    {
        return [EVGroupRequestProgressView height] + 20.0;
    }
    else if (indexPath.row >= EVDashboardPermanentRowCOUNT)
    {
        if ([self.groupRequest.records count] == 0)
            return 190.0;
        return 64.0;
    }
    return 44.0;
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
