//
//  EVFundingSourceViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSourceViewController.h"
#import "EVFundingSourceCell.h"

@interface EVFundingSourceViewController ()

@end

@implementation EVFundingSourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTableView];
    
	// Do any additional setup after loading the view.
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVFundingSourceCell class] forCellReuseIdentifier:@"fundingSourceCell"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EVFundingSourceSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == EVFundingSourceSectionSources)
    {
        if ([self isLoading])
            return 1;
        else
            return MAX(1, [self.fundingSources count]);
    }
    return 1;
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
    EVFundingSourceCell *cell = (EVFundingSourceCell *)[tableView dequeueReusableCellWithIdentifier:@"fundingSourceCell" forIndexPath:indexPath];
    if (indexPath.section == EVFundingSourceSectionSources)
    {
        if ([self isLoading])
        {
            cell.textLabel.text = @"loading...";
            cell.position = EVGroupTableViewCellPositionSingle;
        }
        else if ([self.fundingSources count] == 0) {
            cell.textLabel.text = [self noFundingSourcesAddedString];
            cell.position = EVGroupTableViewCellPositionSingle;
        }
        else
        {
            [cell setUpWithFundingSource:[self.fundingSources objectAtIndex:indexPath.row]];
        }
    }
    else
    {
        [self configureAddNewCell:cell atIndexPath:indexPath];
    }
    
    cell.position = [self cellPositionForIndexPath:indexPath];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVFundingSourceSectionAddNew)
        return NO;
    return ([self.fundingSources count] > 0);
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:self.fundingSources];
//    EVFundingSource *fundingSource = [sourceArray objectAtIndex:indexPath.row];
//    
//    // If we're deleting an active funding source and we have an alternate one available, make one of those the active one
//    if (fundingSource.isActive && [sourceArray count] > 1)
//    {
//        NSInteger sourceIndex = indexPath.row;
//        if (sourceIndex == [sourceArray count] - 1)
//            sourceIndex--;
//        else
//            sourceIndex++;
//        EVFundingSource *replacementSource = [sourceArray objectAtIndex:sourceIndex];
//        [replacementSource activateWithSuccess:^{
//            DLog(@"Successfully changed funding source.");
//            [replacementSource setActive:YES];
//            [fundingSource setActive:NO];
//            [tableView reloadData];
//        } failure:^(NSError *error) {
//            DLog(@"Failed to change funding source.");
//        }];
//    }
//    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.labelText = @"Deleting...";
//    [fundingSource destroyWithSuccess:^{
//        
//        // TODO: MAKE THIS HAPPEN
//        
//        
//        //        [sourceArray removeObjectAtIndex:indexPath.row];
//        //        if (indexPath.section == IVBanksCardsSectionCards)
//        //            self.creditCards = sourceArray;
//        //        else
//        //            self.bankAccounts = sourceArray;
//        
//        [tableView beginUpdates];
//        if ([sourceArray count] == 0)
//            [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
//        else
//            [tableView deleteRowsAtIndexPaths:@[ indexPath ]  withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView endUpdates];
//        [self showSuccessMessage];
//    } failure:^(NSError *error) {
//        DLog(@"Failure: %@", error);
//        [self showErrorMessage];
//    }];
//    
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == EVFundingSourceSectionSources)
    {
        EVFundingSource *selectedFundingSource;
        EVFundingSource *activeFundingSource;
        NSString *hudText;
        
        selectedFundingSource = [self.fundingSources objectAtIndex:indexPath.row];
        activeFundingSource = [self activeFundingSource];
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
    else if (indexPath.section == EVFundingSourceSectionAddNew)
    {
        [self goToAddNewScreenFromSelectedIndexPath:indexPath];
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

#pragma mark - Abstract Methods

- (void)goToAddNewScreenFromSelectedIndexPath:(NSIndexPath *)indexPath {
    // abstract
}

- (void)configureAddNewCell:(EVGroupTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // abstract
}

- (BOOL)isLoading {
    return NO; // abstract
}

- (NSString *)noFundingSourcesAddedString {
    return nil; // abstract
}

- (NSString *)changingActiveString {
    return nil; // abstract
}

@end
