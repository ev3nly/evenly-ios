//
//  EVCardsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCardsViewController.h"
#import "EVCreditCardCell.h"
#import "EVCreditCard.h"
#import "EVAddCardViewController.h"

@interface EVCardsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)loadTableView;

- (NSArray *)creditCards;
- (EVCreditCard *)activeCard;

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
    
    [self loadTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditCardsDidUpdate:)
                                                 name:EVCIAUpdatedCreditCardsNotification
                                               object:nil];

}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVCreditCardCell class] forCellReuseIdentifier:@"creditCardCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EVCardsSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == EVCardsSectionCards)
    {
        if ([[EVCIA sharedInstance] loadingCreditCards])
            return 1;
        else
            return MAX(1, [[[EVCIA sharedInstance] creditCards] count]);
    }
    return EVCardsAddNewRowCOUNT;
}

- (EVGroupTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (rowCount <= 1)
        return EVGroupTableViewCellPositionSingle;
    else {
        if (indexPath.row == 0)
            return EVGroupTableViewCellPositionTop;
        else if (indexPath.row == rowCount - 1)
            return EVGroupTableViewCellPositionBottom;
        else
            return EVGroupTableViewCellPositionCenter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVCreditCardCell *cell = (EVCreditCardCell *)[tableView dequeueReusableCellWithIdentifier:@"creditCardCell" forIndexPath:indexPath];
    if (indexPath.section == EVCardsSectionCards)
    {
        if ([[EVCIA sharedInstance] loadingCreditCards])
        {
            cell.textLabel.text = @"loading...";
            cell.position = EVGroupTableViewCellPositionSingle;
        }
        else if ([self.creditCards count] == 0) {
            cell.textLabel.text = @"No cards added.";
            cell.position = EVGroupTableViewCellPositionSingle;
        }
        else
        {
            NSArray *cards = [[EVCIA sharedInstance] creditCards];
            EVCreditCard *card = [cards objectAtIndex:indexPath.row];
            [cell setUpWithLastFour:card.lastFour andBrandImage:card.brandImage];
            [cell setAccessoryType:(card.active ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
        }
        return cell;
    }
    else
    {
        if (indexPath.row == EVCardsAddNewRowCredit)
            cell.textLabel.text = @"Add Credit Card";
        else
            cell.textLabel.text = @"Add Debit Card";
    }
    
    cell.position = [self cellPositionForIndexPath:indexPath];
    return cell;
    
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == EVCardsSectionCards)
    {
        EVFundingSource *selectedFundingSource;
        EVFundingSource *activeFundingSource;
        NSString *hudText;
        
            selectedFundingSource = [self.creditCards objectAtIndex:indexPath.row];
            activeFundingSource = [self activeCard];
            hudText = @"Setting Active Card";
        
        if (selectedFundingSource == activeFundingSource)
            return;
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = hudText;
        
        [selectedFundingSource activateWithSuccess:^{
            [selectedFundingSource setActive:YES];
            [activeFundingSource setActive:NO];
            [self.tableView reloadData];
            [self showSuccessMessage];
        } failure:^(NSError *error) {
            DLog(@"Failure: %@", error);
            [self showErrorMessage];
        }];
    }
    else if (indexPath.section == EVCardsSectionAddNew)
    {
        EVAddCardViewController *controller = [[EVAddCardViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)showSuccessMessage {
    self.hud.labelText = @"Success!";
    self.hud.mode = MBProgressHUDModeText;
    EV_DISPATCH_AFTER(1.0, ^{ [MBProgressHUD hideHUDForView:self.view animated:YES]; } );
}

- (void)showErrorMessage {
    self.hud.labelText = @"Error";
    self.hud.mode = MBProgressHUDModeText;
    EV_DISPATCH_AFTER(1.0, ^{ [MBProgressHUD hideHUDForView:self.view animated:YES]; } );
}

#pragma mark - Notifications

- (void)creditCardsDidUpdate:(NSNotification *)notification {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Private Methods

- (NSArray *)creditCards {
    return [[EVCIA sharedInstance] creditCards];
}

- (EVCreditCard *)activeCard {
    return (EVCreditCard *)[EVUtilities activeFundingSourceFromArray:[self creditCards]];
}

@end
