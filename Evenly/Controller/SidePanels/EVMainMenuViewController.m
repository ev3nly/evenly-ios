//
//  EVMenuViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuViewController.h"
#import "EVNavigationManager.h"
#import "EVMainMenuCell.h"
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
    self.tableView.backgroundColor = [EVColor sidePanelBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[EVMainMenuCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVMainMenuOptionCOUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVMainMenuCell *cell = (EVMainMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *title = nil;
    UIImage *icon = nil;
    switch (indexPath.row) {
        case EVMainMenuOptionHome:
            title = @"Home";
            icon = [UIImage imageNamed:@"Home"];
            break;
        case EVMainMenuOptionProfile:
            title = [[[EVCIA sharedInstance] me] name] ?: @"Profile";
            icon = [UIImage imageNamed:@"User"];
            break;
        case EVMainMenuOptionSettings:
            title = @"Settings";
            icon = [UIImage imageNamed:@"Settings"];
            break;
        case EVMainMenuOptionSupport:
            title = @"Support";
            icon = [UIImage imageNamed:@"Support"];
            break;
        case EVMainMenuOptionInvite:
            title = @"Invite";
            icon = [UIImage imageNamed:@"Invite"];
            break;
            
        default:
            break;
    }
    [cell.label setText:title];
    [cell.iconView setImage:icon];
    
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
