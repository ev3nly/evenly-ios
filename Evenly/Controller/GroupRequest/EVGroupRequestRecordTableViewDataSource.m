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

#define BUTTON_X_MARGIN 12.0
#define BUTTON_Y_MARGIN 15.0
#define BUTTON_SPACING 10.0
#define BUTTON_WIDTH 276.0
#define BUTTON_HEIGHT 44.0
#define BUTTON_ROW_HEIGHT ((44.0*3) + (BUTTON_Y_MARGIN*2) + (BUTTON_SPACING*2))

@interface EVGroupRequestRecordTableViewDataSource ()

- (void)loadRemindButton;
- (void)loadMarkAsCompletedButton;
- (void)loadCancelButton;


@end


@implementation EVGroupRequestRecordTableViewDataSource

- (id)initWithRecord:(EVGroupRequestRecord *)record {
    self = [super init];
    if (self) {
        self.paymentOptionCell = [[EVGroupRequestPaymentOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                        reuseIdentifier:@"paymentOptionCell"];
        self.record = record;

        [self loadRemindButton];
        [self loadMarkAsCompletedButton];
        [self loadCancelButton];        
    }
    return self;
}

- (void)setRecord:(EVGroupRequestRecord *)record {
    _record = record;
    [self.paymentOptionCell setRecord:record];
}

- (void)loadRemindButton {
    self.remindButton = [[EVBlueButton alloc] initWithFrame:CGRectMake(BUTTON_X_MARGIN,
                                                                       BUTTON_Y_MARGIN,
                                                                       BUTTON_WIDTH,
                                                                       BUTTON_HEIGHT)];
    [self.remindButton setTitle:@"REMIND" forState:UIControlStateNormal];
    
    UIImage *bellImage = [UIImage imageNamed:@"Request-Reminder-Bell"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bellImage];
    imageView.center = CGPointMake(2.0 * bellImage.size.width, self.remindButton.frame.size.height / 2.0);
    [self.remindButton addSubview:imageView];
}

- (void)loadMarkAsCompletedButton {
    self.markAsCompletedButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(BUTTON_X_MARGIN,
                                                                                CGRectGetMaxY(self.remindButton.frame) + BUTTON_SPACING,
                                                                                BUTTON_WIDTH,
                                                                                BUTTON_HEIGHT)];
    [self.markAsCompletedButton setTitle:@"MARK AS COMPLETED" forState:UIControlStateNormal];
}

- (void)loadCancelButton {
    self.cancelButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(BUTTON_X_MARGIN,
                                                                       CGRectGetMaxY(self.markAsCompletedButton.frame) + BUTTON_SPACING,
                                                                       BUTTON_WIDTH,
                                                                       BUTTON_HEIGHT)];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
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
                else if (indexPath.row == 2)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                    [self configureCellForButtons:cell];
                }
            }
            else
            {
                if (indexPath.row == 1) {
                    
                }
                else if (indexPath.row == 2) {
                    self.paymentOptionCell.headerLabel.text = @"Change Payment Option";
                    cell = self.paymentOptionCell;
                }
                else if (indexPath.row == 3) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                    [self configureCellForButtons:cell];
                }
            }
        }
    }
    if (!cell)
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureCellForButtons:(EVGroupedTableViewCell *)cell {
    cell.position = EVGroupedTableViewCellPositionBottom;
    [cell.contentView addSubview:self.remindButton];
    [cell.contentView addSubview:self.markAsCompletedButton];
    [cell.contentView addSubview:self.cancelButton];
}

@end
