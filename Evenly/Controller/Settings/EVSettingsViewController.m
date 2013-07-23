//
//  EVSettingsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSettingsViewController.h"
#import "EVSettingsCell.h"

#import "EVSession.h"
#import "EVNavigationManager.h"

#import "EVFormView.h"

#import "EVNotificationsViewController.h"
#import "EVSetPINViewController.h"

#import "EVWebViewController.h"
#import "EVFacebookManager.h"

#define EV_SETTINGS_MARGIN 10.0
#define EV_SETTINGS_ROW_HEIGHT 50.0
#define EV_SETTINGS_STRIPE_HEIGHT 1.0

@interface EVSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EVSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVSettingsCell class] forCellReuseIdentifier:@"settingsCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EVSettingsSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == EVSettingsSectionMain) {
        return EVSettingsMainRowCOUNT;
    } else if (section == EVSettingsSectionLegal) {
        return EVSettingsLegalRowCOUNT;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVSettingsCell *cell = (EVSettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"settingsCell" forIndexPath:indexPath];
    [cell setPosition:[tableView cellPositionForIndexPath:indexPath]];
    
    if (indexPath.section == EVSettingsSectionMain)
    {
        switch (indexPath.row) {
            case EVSettingsMainRowFacebook:
                cell.iconView.image = [EVImages settingsFacebookIcon];
                cell.label.text = ([EVFacebookManager isConnected] ? @"Disconnect Facebook" : @"Connect Facebook");
                break;
            case EVSettingsMainRowNotifications:
                cell.iconView.image = [EVImages settingsNotificationsIcon];
                cell.label.text = @"Notifications";
                break;
            case EVSettingsMainRowChangePasscode:
                cell.iconView.image = [EVImages settingsPasscodeIcon];
                cell.label.text = @"Change Passcode";
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == EVSettingsSectionLegal)
    {
        switch (indexPath.row) {
            case EVSettingsLegalRowTermsAndConditions:
                cell.iconView.image = nil;
                cell.label.text = @"Terms and Conditions";
                break;
            case EVSettingsLegalRowPrivacyPolicy:
                cell.iconView.image = nil;
                cell.label.text = @"Privacy Policy";
                break;
            default:
                break;
        }
    }
    else
    {
        cell.iconView.image = [EVImages settingsLogoutIcon];
        cell.label.text = @"Logout";
    }
    [cell setNeedsLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == EVSettingsSectionMain)
    {
        switch (indexPath.row) {
            case EVSettingsMainRowFacebook:

                break;
            case EVSettingsMainRowNotifications:
                [self showNotificationsController];
                break;
            case EVSettingsMainRowChangePasscode:
                [self showPasscodeController];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == EVSettingsSectionLegal)
    {
        NSURL *fileURL = nil;
        NSString *title = nil;
        if (indexPath.row == EVSettingsLegalRowTermsAndConditions)
        {
            fileURL = [NSURL fileURLWithPath:EV_BUNDLE_PATH(@"Terms and Conditions.html")];
            title = @"Terms and Conditions";
        }
        else if (indexPath.row == EVSettingsLegalRowPrivacyPolicy)
        {
            fileURL = [NSURL fileURLWithPath:EV_BUNDLE_PATH(@"Privacy Policy.html")];
            title = @"Privacy Policy";
        }
        EVWebViewController *webViewController = [[EVWebViewController alloc] initWithURL:fileURL];
        [webViewController setTitle:title];
        [webViewController setCanDismissManually:NO];
        [webViewController.webView setDataDetectorTypes:UIDataDetectorTypeAll];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else if (indexPath.section == EVSettingsSectionLogout)
    {
        [self showLogOutActionSheet];
    }
}

- (void)showNotificationsController {
    EVNotificationsViewController *notificationsViewController = [[EVNotificationsViewController alloc] init];
    [self.navigationController pushViewController:notificationsViewController animated:YES];
}

- (void)showPasscodeController {
    EVSetPINViewController *pinController = [[EVSetPINViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}


- (void)showLogOutActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles:nil];
    [sheet showInView:self.masterViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet cancelButtonIndex] == buttonIndex)
        return;
    
    [EVSession signOutWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedOutNotification object:nil];
        [self.masterViewController showOnboardingControllerWithCompletion:^{
            [self.masterViewController setCenterPanel:[[EVNavigationManager sharedManager] homeViewController]];
        } animated:YES];
    } failure:^(NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
