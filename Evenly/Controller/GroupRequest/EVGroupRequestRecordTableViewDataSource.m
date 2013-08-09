//
//  EVGropuRequestRecordTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecordTableViewDataSource.h"
#import "EVGroupRequestUserCell.h"
#import "EVGroupRequestCompletedCell.h"

#define USER_ROW_HEIGHT 64.0

#define BUTTON_X_MARGIN 12.0
#define BUTTON_Y_MARGIN 15.0
#define BUTTON_SPACING 10.0
#define BUTTON_WIDTH 276.0
#define BUTTON_HEIGHT 44.0

#define BUTTON_ROW_HEIGHT ((44.0*2) + (BUTTON_Y_MARGIN*2) + (BUTTON_SPACING*1))
//#define BUTTON_ROW_HEIGHT_WITHOUT_CANCEL ((44.0*2) + (BUTTON_Y_MARGIN*2) + (BUTTON_SPACING*1))

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
        [self.paymentOptionCell setRecord:record];

        [self loadRemindButton];
//        [self loadMarkAsCompletedButton];
        [self loadCancelButton];
    }
    return self;
}

- (void)setRecord:(EVGroupRequestRecord *)record {
    
    BOOL shouldReloadBalance = !!(record.tier);
    _record = record;
    [self.paymentOptionCell setRecord:record];
    if (shouldReloadBalance) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0] ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
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
//                                                                       CGRectGetMaxY(self.markAsCompletedButton.frame) + BUTTON_SPACING,
                                                                       CGRectGetMaxY(self.remindButton.frame) + BUTTON_SPACING,

                                                                       BUTTON_WIDTH,
                                                                       BUTTON_HEIGHT)];
    [self.cancelButton setTitle:@"CANCEL REQUEST" forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVGroupRequestRecordRowCOUNT;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVGroupRequestRecordRowHeader)
        return USER_ROW_HEIGHT;
    
    if (self.record.completed) {
        if (indexPath.row == EVGroupRequestRecordRowStatement) // payment history
            return [EVGroupRequestStatementCell heightForRecord:self.record];
        if (indexPath.row == EVGroupRequestRecordRowPaymentOption) // "completed" indicator
            return 44.0;
        // EVGroupRequestRecordRowButtons height = 0.

    } else {
        if (!self.record.tier) // unassigned
        {
            // EVGroupRequestRecordRowStatement height = 0.
            
            if (indexPath.row == EVGroupRequestRecordRowPaymentOption) // payment option cell
                return [self.paymentOptionCell heightForRecord:self.record];
            else if (indexPath.row == EVGroupRequestRecordRowButtons)
                return BUTTON_ROW_HEIGHT;
        }
        else // assigned
        {
            if (indexPath.row == EVGroupRequestRecordRowStatement) // payment history
                return [EVGroupRequestStatementCell heightForRecord:self.record];
            if (indexPath.row == EVGroupRequestRecordRowPaymentOption)
                return [self.paymentOptionCell heightForRecord:self.record];
            else if (indexPath.row == EVGroupRequestRecordRowButtons) {
                return BUTTON_ROW_HEIGHT;
//                if (self.record.numberOfPayments == 0)
//                    return BUTTON_ROW_HEIGHT;
//                else
//                    return BUTTON_ROW_HEIGHT_WITHOUT_CANCEL;
            }
        }
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    if (indexPath.row == EVGroupRequestRecordRowHeader) {
        EVGroupRequestUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        userCell.nameLabel.text = self.record.user.name;
        userCell.avatarView.avatarOwner = self.record.user;
        cell = userCell;
    }
    else
    {
        if (self.record.completed)
        {
            [self.remindButton removeFromSuperview];
            [self.markAsCompletedButton removeFromSuperview];
            [self.cancelButton removeFromSuperview];
            
            if (indexPath.row == EVGroupRequestRecordRowStatement)
            {
                cell = [self statementCellForIndexPath:indexPath];
            }
            else if (indexPath.row == EVGroupRequestRecordRowPaymentOption)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"completedCell" forIndexPath:indexPath];
            }
        }
        else
        {
            if (!self.record.tier)
            {
                if (indexPath.row == EVGroupRequestRecordRowPaymentOption)
                {
                    self.paymentOptionCell.headerLabel.text = @"Set a Payment Option";
                    cell = self.paymentOptionCell;
                }
                else if (indexPath.row == EVGroupRequestRecordRowButtons)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                    [self configureCellForButtons:cell];
                }
            }
            else
            {
                if (indexPath.row == EVGroupRequestRecordRowStatement)
                {
                    cell = [self statementCellForIndexPath:indexPath];
                }
                else if (indexPath.row == EVGroupRequestRecordRowPaymentOption)
                {
                    if (self.record.numberOfPayments == 0)
                        self.paymentOptionCell.headerLabel.text = @"Change Payment Option";
                    else
                        self.paymentOptionCell.headerLabel.text = nil;
                    
                    cell = self.paymentOptionCell;
                }
                else if (indexPath.row == EVGroupRequestRecordRowButtons)
                {
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

- (EVGroupRequestStatementCell *)statementCellForIndexPath:(NSIndexPath *)indexPath {
    EVGroupRequestStatementCell *statementCell = [self.tableView dequeueReusableCellWithIdentifier:@"statementCell" forIndexPath:indexPath];
    [statementCell configureForRecord:self.record];
    return statementCell;
}

- (void)configureCellForButtons:(EVGroupedTableViewCell *)cell {
    cell.position = EVGroupedTableViewCellPositionBottom;
    [cell.contentView addSubview:self.remindButton];
    [cell.contentView addSubview:self.markAsCompletedButton];
    if (self.record.numberOfPayments == 0)
        [cell.contentView addSubview:self.cancelButton];
    else
        [self.cancelButton removeFromSuperview];
}

@end
