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

@property (nonatomic, strong) EVNoFundingSourcesCell *noFundingSourcesCell;

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

    // Make sure the edit button is big enough to accommodate "Done"
    self.editButton = [[EVNavigationBarButton alloc] initWithTitle:@"Done"];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self updateEditButton];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVFundingSourceCell class] forCellReuseIdentifier:@"fundingSourceCell"];
    [self.tableView registerClass:[EVNoFundingSourcesCell class] forCellReuseIdentifier:@"noFundingSourcesCell"];
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView addReassuringMessage];
    [self.view addSubview:self.tableView];
}

#pragma mark - Edit Button

- (void)updateEditButton {
    if ([self.fundingSources count] > 0) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.editButton]];
    } else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (void)editButtonPress:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
//    self.tableView.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVFundingSourceSectionSources) {
        if (![self isLoading] && [self.fundingSources count] == 0) {
            return [EVNoFundingSourcesCell height];
        }
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == EVFundingSourceSectionSources && ![self isLoading] && [self.fundingSources count] == 0)
    {
        EVNoFundingSourcesCell *noFundingSourcesCell = (EVNoFundingSourcesCell *)[tableView dequeueReusableCellWithIdentifier:@"noFundingSourcesCell" forIndexPath:indexPath];
        [noFundingSourcesCell setUpWithIllustration:[self noFundingSourcesImage]
                                                    text:[self noFundingSourcesAddedString]];
        noFundingSourcesCell.position = EVGroupedTableViewCellPositionSingle;
        noFundingSourcesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return noFundingSourcesCell;
    }
    
    EVFundingSourceCell *cell = (EVFundingSourceCell *)[tableView dequeueReusableCellWithIdentifier:@"fundingSourceCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    if (indexPath.section == EVFundingSourceSectionSources)
    {
        if ([self isLoading])
        {
            cell.textLabel.text = @"Loading...";
            cell.position = EVGroupedTableViewCellPositionSingle;
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
    
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVFundingSourceSectionAddNew)
        return NO;
    return ([self.fundingSources count] > 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block NSArray *sourceArray = self.fundingSources;
    EVFundingSource *fundingSource = [sourceArray objectAtIndex:indexPath.row];
    
    // If we're deleting an active funding source and we have an alternate one available, make one of those the active one
    if (fundingSource.isActive && [sourceArray count] > 1)
    {
        NSInteger sourceIndex = indexPath.row;
        if (sourceIndex == [sourceArray count] - 1)
            sourceIndex--;
        else
            sourceIndex++;
        EVFundingSource *replacementSource = [sourceArray objectAtIndex:sourceIndex];
        [replacementSource activateWithSuccess:^{
            DLog(@"Successfully changed funding source.");
            [replacementSource setActive:YES];
            [fundingSource setActive:NO];
            [tableView reloadData];
        } failure:^(NSError *error) {
            DLog(@"Failed to change funding source.");
        }];
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Deleting...";
    [[EVCIA sharedInstance] deleteFundingSource:fundingSource
                                    withSuccess:^{
                                        [tableView beginUpdates];
                                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                                 withRowAnimation:UITableViewRowAnimationAutomatic];
                                        [tableView endUpdates];
                                        [self showSuccessMessage];
                                    } failure:^(NSError *error) {
                                        DLog(@"Failure: %@", error);
                                        [self showErrorMessage];
                                    }];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.fundingSources count] == 0 &&
        indexPath.section == EVFundingSourceSectionSources &&
        indexPath.row == 0) {
        return nil;
    }
    
    if (tableView.editing && indexPath.section == EVFundingSourceSectionSources)
        return nil;
    
    return indexPath;
}

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

- (void)configureAddNewCell:(EVGroupedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.imageView.image = [EVImages banksCardsAddIcon];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[EVImages dashboardDisclosureArrow]];
}

- (BOOL)isLoading {
    return NO; // abstract
}

- (UIImage *)noFundingSourcesImage {
    return nil; //abstract
}

- (NSString *)noFundingSourcesAddedString {
    return nil; // abstract
}

- (NSString *)changingActiveString {
    return nil; // abstract
}

@end
