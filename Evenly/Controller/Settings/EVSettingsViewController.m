//
//  EVSettingsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSettingsViewController.h"
#import "EVSettingsRow.h"

#import "EVSession.h"
#import "EVNavigationManager.h"

#import "EVFormView.h"

#define EV_SETTINGS_MARGIN 10.0
#define EV_SETTINGS_ROW_HEIGHT 50.0
#define EV_SETTINGS_STRIPE_HEIGHT 1.0

@interface EVSettingsViewController ()

@property (nonatomic, strong) EVFormView *panel;
@property (nonatomic, strong) EVSettingsRow *notificationsRow;
@property (nonatomic, strong) EVSettingsRow *passcodeRow;
@property (nonatomic, strong) EVSettingsRow *logoutRow;

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
    self.panel = [[EVFormView alloc] initWithFrame:CGRectMake(EV_SETTINGS_MARGIN,
                                                               EV_SETTINGS_MARGIN,
                                                               self.view.frame.size.width - 2*EV_SETTINGS_MARGIN,
                                                               EV_SETTINGS_ROW_HEIGHT * 3 + EV_SETTINGS_STRIPE_HEIGHT * 4)];
    [self.view addSubview:self.panel];
    
    CGFloat yOrigin = 1.0;
    EVSettingsRow *row = nil;
    CGRect frame = CGRectMake(1, 1, self.panel.frame.size.width-2, EV_SETTINGS_ROW_HEIGHT);
    
    row = [[EVSettingsRow alloc] initWithFrame:frame];
    row.iconView.image = [UIImage imageNamed:@"Settings_notification_globe"];
    row.label.text = @"Notifications";
    self.notificationsRow = row;
    yOrigin += EV_SETTINGS_ROW_HEIGHT;
    
    row = [[EVSettingsRow alloc] initWithFrame:frame];
    row.iconView.image = [UIImage imageNamed:@"Settings_passcode_key"];
    row.label.text = @"Passcode";
    self.passcodeRow = row;
    yOrigin += EV_SETTINGS_ROW_HEIGHT;

    row = [[EVSettingsRow alloc] initWithFrame:frame];
    row.iconView.image = [UIImage imageNamed:@"Settings_logout_arrow"];
    row.label.text = @"Logout";
    self.logoutRow = row;
    yOrigin += EV_SETTINGS_ROW_HEIGHT;
    
    [self.panel setFormRows:@[ self.notificationsRow, self.passcodeRow, self.logoutRow ]];
    
    [self.notificationsRow addTarget:self action:@selector(notificationsButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.passcodeRow addTarget:self action:@selector(passcodeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutRow addTarget:self action:@selector(logoutButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)notificationsButtonPress:(id)sender {
    
}

- (void)passcodeButtonPress:(id)sender {
    
}

- (void)logoutButtonPress:(id)sender {
    [self showLogOutActionSheet];
}

- (void)showLogOutActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles:nil];
    [sheet showInView:self.masterViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet cancelButtonIndex] == buttonIndex)
        return;
    
    [EVSession signOutWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionUserExplicitlySignedOutNotification object:nil];
        [self.masterViewController showLoginViewControllerWithCompletion:^{
            [self.masterViewController setCenterPanel:[[EVNavigationManager sharedManager] homeViewController]];
        }
                                                                animated:YES
                                                   authenticationSuccess:^{
//                                                       [self.masterViewController promptToSetPIN];
                                                   } ];
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
