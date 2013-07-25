//
//  EVHistoryDepositViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryDepositViewController.h"

@interface EVHistoryDepositViewController ()

@property (nonatomic, strong) EVWithdrawal *withdrawal;

@end

@implementation EVHistoryDepositViewController

- (id)initWithWithdrawal:(EVWithdrawal *)withdrawal {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.withdrawal = withdrawal;
        self.title = @"Deposit Details";
    }
    return self;
}


- (NSString *)fieldTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fieldText = nil;
    switch (indexPath.row) {
        case EVHistoryDepositRowBank:
            fieldText = @"Bank:";
            break;
        case EVHistoryDepositRowAmount:
            fieldText = @"Amount:";
            break;
        case EVHistoryDepositRowDate:
            fieldText = @"Date:";
            break;
        default:
            break;
    }
    return fieldText;
}

- (NSString *)valueTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fieldText = nil;
    switch (indexPath.row) {
        case EVHistoryDepositRowBank:
            fieldText = self.withdrawal.bankName;
            break;
        case EVHistoryDepositRowAmount:
            fieldText = [EVStringUtility amountStringForAmount:self.withdrawal.amount];
            break;
        case EVHistoryDepositRowDate:
            fieldText = [NSDateFormatter localizedStringFromDate:self.withdrawal.createdAt
                                                       dateStyle:NSDateFormatterMediumStyle
                                                       timeStyle:NSDateFormatterMediumStyle];
            break;
        default:
            break;
    }
    return fieldText;
}

- (NSString *)emailSubjectLine {
    return [NSString stringWithFormat:@"Deposit %@", self.withdrawal.dbid];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVHistoryDepositRowCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVHistoryItemCell heightForValueText:[self valueTextForRowAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    EVHistoryItemCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"EVHistoryItemCell" forIndexPath:indexPath];
    [historyCell.fieldLabel setText:[self fieldTextForRowAtIndexPath:indexPath]];
    [historyCell.valueLabel setText:[self valueTextForRowAtIndexPath:indexPath]];
    [historyCell setPosition:[tableView cellPositionForIndexPath:indexPath]];
    return historyCell;
}

@end
