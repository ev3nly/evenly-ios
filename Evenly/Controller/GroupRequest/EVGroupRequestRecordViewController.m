//
//  EVGroupRequestRecordViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecordViewController.h"
#import "EVGroupRequestUserCell.h"
#import "EVGroupRequestPaymentOptionCell.h"

#import "EVGroupRequest.h"

@interface EVGroupRequestRecordViewController ()

@end

@implementation EVGroupRequestRecordViewController

- (id)initWithRecord:(EVGroupRequestRecord *)record {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.record = record;
        self.title = self.record.groupRequest.title;
        self.dataSource = [[EVGroupRequestRecordTableViewDataSource alloc] initWithRecord:self.record];
        
        for (UIButton *button in self.dataSource.paymentOptionCell.optionButtons) {
            [button addTarget:self action:@selector(paymentOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.dataSource.remindButton addTarget:self action:@selector(remindButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.dataSource.markAsCompletedButton addTarget:self action:@selector(markAsCompletedButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.dataSource.cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVGroupRequestUserCell class] forCellReuseIdentifier:@"userCell"];
    [self.tableView registerClass:[EVGroupRequestPaymentOptionCell class] forCellReuseIdentifier:@"paymentOptionCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForRowAtIndexPath:indexPath];
}

#pragma mark - Button Actions

- (void)paymentOptionButtonPress:(UIButton *)button {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SETTING PAYMENT OPTION..."];
    
    UIButton *oldButton = nil;
    for (oldButton in self.dataSource.paymentOptionCell.optionButtons) {
        if (oldButton.selected)
            break;
    }
    [oldButton setSelected:NO];
    [button setSelected:YES];
    NSInteger index = [self.dataSource.paymentOptionCell.optionButtons indexOfObject:button];
    [self.record setTier:[self.record.groupRequest.tiers objectAtIndex:index]];
    [self.record.groupRequest updateRecord:self.record
                               withSuccess:^(EVGroupRequestRecord *record) {
                                   self.record = record;
                                   [self.dataSource setRecord:self.record];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                               } failure:^(NSError *error) {
                                   DLog(@"Failed to update record: %@", error);
                                   [oldButton setSelected:YES];
                                   [button setSelected:NO];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                               }];
}

- (void)remindButtonPress:(id)sender {
    
}

- (void)markAsCompleteButtonPress:(id)sender {
    
}

- (void)cancelButtonPress:(id)sender {
    
}

@end
