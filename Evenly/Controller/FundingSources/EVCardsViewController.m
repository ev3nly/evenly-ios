//
//  EVCardsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCardsViewController.h"
#import "EVFundingSourceCell.h"
#import "EVCreditCard.h"
#import "EVAddCardViewController.h"

@interface EVCardsViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EVCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Cards";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditCardsDidUpdate:)
                                                 name:EVCIAUpdatedCreditCardsNotification
                                               object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == EVFundingSourceSectionAddNew)
        return EVCardsAddNewRowCOUNT;
    return [super tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - Abstract Implementations

- (NSArray *)fundingSources {
    return [[EVCIA sharedInstance] creditCards];
}

- (EVFundingSource *)activeFundingSource {
    return [[EVCIA sharedInstance] activeCreditCard];
}

- (BOOL)isLoading {
    return [[EVCIA sharedInstance] loadingCreditCards];
}

- (void)configureAddNewCell:(EVGroupedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [super configureAddNewCell:cell atIndexPath:indexPath];
    if (indexPath.row == EVCardsAddNewRowCredit)
        cell.textLabel.text = @"Add Credit Card";
    else
        cell.textLabel.text = @"Add Debit Card";
}

- (void)goToAddNewScreenFromSelectedIndexPath:(NSIndexPath *)indexPath {
    EVAddCardViewController *controller = [[EVAddCardViewController alloc] init];
    if (indexPath.row == EVCardsAddNewRowDebit)
        [controller setIsDebitCard:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIImage *)noFundingSourcesImage {
    return [EVImages cardIllustration];
}

- (NSString *)noFundingSourcesAddedString {
    return @"You haven't added any cards yet.";
}

- (NSString *)changingActiveString {
    return @"Setting Active Card";
}

#pragma mark - Notifications

- (void)creditCardsDidUpdate:(NSNotification *)notification {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self updateEditButton];
}

@end
