//
//  EVGropuRequestRecordTableViewDataSource.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVGroupRequestPaymentOptionCell.h"
#import "EVGroupRequestStatementCell.h"
#import "EVGroupRequestRecord.h"
#import "EVBlueButton.h"
#import "EVGrayButton.h"

typedef enum {
    EVGroupRequestRecordRowHeader,
    EVGroupRequestRecordRowStatement,
    EVGroupRequestRecordRowPaymentOption,
    EVGroupRequestRecordRowButtons,
    EVGroupRequestRecordRowCOUNT
} EVGroupRequestRecordRow;

@interface EVGroupRequestRecordTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) EVGroupRequestRecord *record;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) EVGroupRequestPaymentOptionCell *paymentOptionCell;

@property (nonatomic, strong) EVBlueButton *remindButton;
@property (nonatomic, strong) EVGrayButton *markAsCompletedButton;
@property (nonatomic, strong) EVGrayButton *cancelButton;

- (id)initWithRecord:(EVGroupRequestRecord *)record;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
