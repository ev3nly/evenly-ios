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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setLoading:self.withdrawal.loading];
    [self.tableView setTableFooterView:(self.withdrawal.loading ? nil : self.footerView)];
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
    if (self.withdrawal.loading)
        return 0;
    return EVHistoryDepositRowCOUNT;
}

@end
