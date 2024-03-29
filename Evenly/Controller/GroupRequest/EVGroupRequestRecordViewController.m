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
#import "EVGroupRequestStatementCell.h"
#import "EVGroupRequestCompletedCell.h"

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
        [self hookUpOptionButtons];
        
        [self.dataSource.remindButton addTarget:self action:@selector(remindButtonPress:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.tableView registerClass:[EVGroupRequestStatementCell class] forCellReuseIdentifier:@"statementCell"];
    [self.tableView registerClass:[EVGroupRequestCompletedCell class] forCellReuseIdentifier:@"completedCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.record.tier)
    {
        [self.record.groupRequest allPaymentsForRecord:self.record
                                           withSuccess:^(NSArray *payments) {
                                               [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0] ]
                                                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                                           } failure:^(NSError *error) {
                                               DLog(@"Failed to get payments: %@", error);
                                           }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForRowAtIndexPath:indexPath];
}

- (void)hookUpOptionButtons {
    for (UIButton *button in self.dataSource.paymentOptionCell.optionButtons) {
        [button addTarget:self action:@selector(paymentOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Button Actions

static BOOL _currentlySettingOption = NO;

- (void)paymentOptionButtonPress:(UIButton *)button {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SETTING PAYMENT OPTION..."];
    
    UIButton *oldButton = nil;
    for (oldButton in self.dataSource.paymentOptionCell.optionButtons) {
        if (oldButton.isSelected)
            break;
    }
    if (_currentlySettingOption || oldButton == button)
        return;
    
    [oldButton setSelected:NO];
    [button setSelected:YES];
    NSInteger index = [self.dataSource.paymentOptionCell.optionButtons indexOfObject:button];
    [self.record setTier:[self.record.groupRequest.tiers objectAtIndex:index]];
    
    _currentlySettingOption = YES;
    [self.record.groupRequest updateRecord:self.record
                               withSuccess:^(EVGroupRequestRecord *record) {
                                   self.record = record;
                                   [self.dataSource setRecord:self.record];
                                   [self hookUpOptionButtons];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                                   _currentlySettingOption = NO;
                               } failure:^(NSError *error) {
                                   DLog(@"Failed to update record: %@", error);
                                   [oldButton setSelected:YES];
                                   [button setSelected:NO];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                                   _currentlySettingOption = NO;
                               }];
}

- (void)remindButtonPress:(id)sender {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING REMINDER..."];
    [self.record.groupRequest remindRecord:self.record
                               withSuccess:^{
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                               } failure:^(NSError *error) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                               }];
}

- (void)cancelButtonPress:(id)sender {
    
    // If this is the only record left in the group request, we need to:
    // a) inform the user that by doing this, they'll be closing the whole request, and
    // b) close the whole thing.
    if (self.record.groupRequest.records.count == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Close the Request?"
                                                        message:@"This is the only person left in this group request.  Do you want to close the request?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
        return;
    }
    
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"MARKING COMPLETE..."];
    [self.record.groupRequest deleteRecord:self.record
                               withSuccess:^{
                                   [EVStatusBarManager sharedManager].duringSuccess = ^{
                                       if (self.delegate)
                                           [self.delegate viewController:self deletedRecord:self.record];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   };
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                               } failure:^(NSError *error) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                               }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex])
        return;

    [self closeRequest];
}

- (void)closeRequest {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CLOSING REQUEST..."];
    [self.record.groupRequest setCompleted:YES];
    [self.record.groupRequest updateWithSuccess:^{
        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
        [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            }];
        };
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

@end
