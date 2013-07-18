//
//  EVBanksViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVBanksViewController.h"
#import "EVFundingSourceCell.h"
#import "EVBankAccount.h"
#import "EVAddBankViewController.h"

@interface EVBanksViewController ()

@end

@implementation EVBanksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Banks";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bankAccountsDidUpdate:)
                                                 name:EVCIAUpdatedBankAccountsNotification
                                               object:nil];
}

#pragma mark - Abstract Implementations

- (NSArray *)fundingSources {
    return [[EVCIA sharedInstance] bankAccounts];
}

- (EVFundingSource *)activeFundingSource {
    return [[EVCIA sharedInstance] activeBankAccount];
}

- (BOOL)isLoading {
    return [[EVCIA sharedInstance] loadingBankAccounts];
}

- (void)configureAddNewCell:(EVGroupedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = @"Add Bank Account";
}

- (void)goToAddNewScreenFromSelectedIndexPath:(NSIndexPath *)indexPath {
    EVAddBankViewController *controller = [[EVAddBankViewController alloc] init];
    controller.canDismissManually = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)noFundingSourcesAddedString {
    return @"No accounts added.";
}

- (NSString *)changingActiveString {
    return @"Setting Active Account";
}

#pragma mark - Notifications

- (void)bankAccountsDidUpdate:(NSNotification *)notification {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
