//
//  EVMenuViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuViewController.h"
#import "EVNavigationManager.h"

@interface EVMainMenuViewController ()

@end

@implementation EVMainMenuViewController

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
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"View will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    DLog(@"View did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    DLog(@"View will disappear");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVMainMenuOptionCOUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *title = nil;
    switch (indexPath.row) {
        case EVMainMenuOptionHome:
            title = @"Home";
            break;
        case EVMainMenuOptionProfile:
            title = @"Profile";
            break;
        case EVMainMenuOptionSettings:
            title = @"Settings";
            break;
        case EVMainMenuOptionSupport:
            title = @"Support";
            break;
        case EVMainMenuOptionInvite:
            title = @"Invite";
            break;
            
        default:
            break;
    }
    [cell.textLabel setText:title];
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVMainMenuOptionSupport)
    {
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setToRecipients:@[ [EVStringUtility supportEmail] ]];
        [composer setSubject:[EVStringUtility supportEmailSubjectLine]];
        [composer setMailComposeDelegate:self];
        [self presentViewController:composer
                           animated:YES
                         completion:nil];
        return;
    }
    
    UIViewController *viewController = nil;
    switch (indexPath.row) {
        case EVMainMenuOptionHome:
            viewController = [[EVNavigationManager sharedManager] homeViewController];
            break;
        case EVMainMenuOptionProfile:
            viewController = [[EVNavigationManager sharedManager] profileViewController];
            break;
        case EVMainMenuOptionSettings:
            viewController = [[EVNavigationManager sharedManager] settingsViewController];
            break;
        case EVMainMenuOptionInvite:
            viewController = [[EVNavigationManager sharedManager] inviteViewController];
            break;
        case EVMainMenuOptionSupport:
        default:
            break;
    }
    if (viewController)
    {
        self.masterViewController.centerPanel = viewController;
    }
}


#pragma mark - Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - EVSidePanelViewController Overrides

- (JASidePanelState)visibleState {
    return JASidePanelLeftVisible;
}

@end
