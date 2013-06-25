//
//  EVGropuRequestRecordTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecordTableViewDataSource.h"
#import "EVGroupRequestUserCell.h"

#import "EVGroupRequestPaymentOptionCell.h"

#define USER_ROW_HEIGHT 64.0

#define BUTTON_ROW_HEIGHT ((44.0*3) + (10.0*4))

@implementation EVGroupRequestRecordTableViewDataSource

- (id)initWithRecord:(EVGroupRequestRecord *)record {
    self = [super init];
    if (self) {
        self.record = record;
        self.paymentOptionCell = [[EVGroupRequestPaymentOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                        reuseIdentifier:@"paymentOptionCell"];
        [self.paymentOptionCell setRecord:record];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Unpaid, unassigned
    if (self.record.tier == nil)
        return 3;
    
    // Fully paid
    if (self.record.completed)
        return 3;
    
    // Unpaid, assigned / partially paid
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    if (indexPath.row == 0) {
        EVGroupRequestUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        userCell.nameLabel.text = self.record.user.name;
        userCell.avatarView.avatarOwner = self.record.user;
        cell = userCell;
    }
    else
    {
        if (self.record.completed)
        {
            
        }
        else
        {
            if (!self.record.tier)
            {
                if (indexPath.row == 1)
                {
                    self.paymentOptionCell.headerLabel.text = @"Set a Payment Option";
                    cell = self.paymentOptionCell;
                }
            }
            else
            {
                if (indexPath.row == 1) {
                    
                }
                if (indexPath.row == 2) {
                    self.paymentOptionCell.headerLabel.text = @"Change Payment Option";
                    cell = self.paymentOptionCell;
                }
            }
        }
    }
    if (!cell)
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return USER_ROW_HEIGHT;
    
    if (self.record.completed) {
        if (indexPath.row == 1) // payment history
            return 44.0;
        if (indexPath.row == 2) // "completed" indicator
            return 44.0;
    } else {
        if (!self.record.tier) // unassigned
        {
            if (indexPath.row == 1) // payment option cell
                return [self.paymentOptionCell heightForRecord:self.record];
            else
                return BUTTON_ROW_HEIGHT;
        }
        else // assigned
        {
            if (indexPath.row == 1) // payment history
                return 44.0;
            if (indexPath.row == 2)
                return [self.paymentOptionCell heightForRecord:self.record];
            else
                return BUTTON_ROW_HEIGHT;
        }
    }
    return 44.0;
}

@end
