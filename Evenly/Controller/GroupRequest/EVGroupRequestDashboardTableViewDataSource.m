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
#import "EVSegmentedControl.h"
#import "EVDashboardTitleCell.h"
#import "EVDashboardUserCell.h"

@implementation EVGroupRequestDashboardTableViewDataSource

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [super init];
    if (self) {
        self.groupRequest = groupRequest;
        self.segmentedControl = [[EVSegmentedControl alloc] initWithItems:@[ @"All", @"Paying", @"Paid" ]];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.groupRequest.records count] == 0) {
        return EVDashboardPermanentRowCOUNT + 1;
    }
    return EVDashboardPermanentRowCOUNT + [self.groupRequest.records count];
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
    }
    else if (indexPath.row == EVDashboardPermanentRowSegmentedControl)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setPosition:EVGroupedTableViewCellPositionCenter];
        [self.segmentedControl setFrame:CGRectMake(0, 0, cell.frame.size.width, 44.0)];
        [cell addSubview:self.segmentedControl];
    }
    else
    {
        if ([self.groupRequest.records count] > 0)
        {
            EVDashboardUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
            EVGroupRequestRecord *record = [self.groupRequest.records objectAtIndex:(indexPath.row - EVDashboardPermanentRowCOUNT)];
            [userCell.nameLabel setText:record.user.name];
            [userCell.avatarView setAvatarOwner:record.user];
            [userCell.tierLabel setText:record.tier.name];
            
            if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section])
                userCell.position = EVGroupedTableViewCellPositionBottom;
            else
                userCell.position = EVGroupedTableViewCellPositionCenter;
            cell = userCell;
        }
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    return cell;
}



@end
