//
//  EVHistoryPaymentViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryPaymentViewController.h"

@interface EVHistoryPaymentViewController () {
    BOOL _loading;
}

@property (nonatomic, strong) EVPayment *payment;

@end

@implementation EVHistoryPaymentViewController

- (id)initWithPayment:(EVPayment *)payment {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.payment = payment;
        self.title = @"Payment Details";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setLoading:self.payment.loading];
    [self.tableView setTableFooterView:(self.payment.loading ? nil : self.footerView)];
}

#pragma mark - EVReloadable

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [self.tableView setLoading:_loading];
}

- (BOOL)isLoading {
    return _loading;
}

- (void)reload {
    [self.tableView reloadData];
    [self.tableView setLoading:NO];
    [self.tableView setTableFooterView:self.footerView];
}


- (NSString *)fieldTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fieldText = nil;
    switch (indexPath.row) {
        case EVHistoryPaymentRowFrom:
            fieldText = @"From:";
            break;
        case EVHistoryPaymentRowTo:
            fieldText = @"To:";
            break;
        case EVHistoryPaymentRowAmount:
            fieldText = @"Amount:";
            break;
        case EVHistoryPaymentRowFor:
            fieldText = @"For:";
            break;
        case EVHistoryPaymentRowDate:
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
        case EVHistoryPaymentRowFrom:
            fieldText = (self.payment.from ? [self.payment.from name] : @"You");
            break;
        case EVHistoryPaymentRowTo:
            fieldText = (self.payment.to ? [self.payment.to name] : @"You");
            break;
        case EVHistoryPaymentRowAmount:
            fieldText = [EVStringUtility amountStringForAmount:self.payment.amount];
            break;
        case EVHistoryPaymentRowFor:
            fieldText = self.payment.memo;
            break;
        case EVHistoryPaymentRowDate:
            fieldText = [NSDateFormatter localizedStringFromDate:self.payment.createdAt
                                                       dateStyle:NSDateFormatterMediumStyle
                                                       timeStyle:NSDateFormatterMediumStyle];
            break;
        default:
            break;
    }
    return fieldText;
}

- (id<EVAvatarOwning>)avatarOwnerForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<EVAvatarOwning> owner = nil;
    if (indexPath.row == EVHistoryPaymentRowFrom)
    {
        owner = (self.payment.from ?: [EVCIA me]);
    }
    else if (indexPath.row == EVHistoryPaymentRowTo)
    {
        owner = (self.payment.to ?: [EVCIA me]);
    }
    return owner;
}

- (NSString *)emailSubjectLine {
    return [NSString stringWithFormat:@"Payment %@", self.payment.dbid];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.payment.loading)
        return 0;
    return EVHistoryPaymentRowCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVHistoryPaymentRowFrom || indexPath.row == EVHistoryPaymentRowTo) {
        return [EVHistoryItemUserCell heightForValueText:[self valueTextForRowAtIndexPath:indexPath]];
    }
    return [EVHistoryItemCell heightForValueText:[self valueTextForRowAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EVHistoryItemCell *historyCell;
    if (indexPath.row == EVHistoryPaymentRowFrom || indexPath.row == EVHistoryPaymentRowTo) {
        EVHistoryItemUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"EVHistoryItemUserCell" forIndexPath:indexPath];
        [userCell.avatarView setAvatarOwner:[self avatarOwnerForRowAtIndexPath:indexPath]];
        historyCell = userCell;
    } else {
        historyCell = [tableView dequeueReusableCellWithIdentifier:@"EVHistoryItemCell" forIndexPath:indexPath];
    }
    
    [historyCell.fieldLabel setText:[self fieldTextForRowAtIndexPath:indexPath]];
    [historyCell.valueLabel setText:[self valueTextForRowAtIndexPath:indexPath]];
    [historyCell setPosition:[tableView cellPositionForIndexPath:indexPath]];
    return historyCell;
}


@end
