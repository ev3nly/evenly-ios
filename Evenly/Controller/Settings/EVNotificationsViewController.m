//
//  EVNotificationsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNotificationsViewController.h"
#import "EVSettingsManager.h"
#import "EVPushManager.h"

#import "EVFormView.h"
#import "EVFormRow.h"
#import "EVSwitch.h"

#define CONTEXT_LABEL_X_MARGIN 20.0
#define CONTEXT_LABEL_Y_MARGIN 15.0
#define CONTEXT_LABEL_HEIGHT 20.0

#define FORM_CELL_SIDE_MARGIN ([EVUtilities userHasIOS7] ? 0 : 10)
#define FORM_Y_ORIGIN 44.0
#define FORM_MARGIN ([EVUtilities userHasIOS7] ? 10.0 : 0)
#define FORM_ROW_HEIGHT 50.0

@interface EVNotificationsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *contextLabel;
@property (nonatomic, strong) EVFormView *form;

@property (nonatomic, strong) EVSwitch *pushSwitch;
@property (nonatomic, strong) EVSwitch *emailSwitch;
@property (nonatomic, strong) EVSwitch *smsSwitch;

- (void)loadContextLabel;
- (void)loadForm;
- (void)loadRows;

@end

@implementation EVNotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Notifications";
        self->_setting = [[EVSettingsManager sharedManager] notificationSetting];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView]; // Use the table view for the scrolling feel, nothing else.
    
    [self loadContextLabel];
    [self loadForm];
    [self loadRows];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingsDidReload:)
                                                 name:EVSettingsWereLoadedFromServerNotification
                                               object:nil];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.view addSubview:self.tableView];
}

- (void)loadContextLabel {
    self.contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTEXT_LABEL_X_MARGIN,
                                                                  CONTEXT_LABEL_Y_MARGIN,
                                                                  self.view.frame.size.width - 2*CONTEXT_LABEL_X_MARGIN,
                                                                  CONTEXT_LABEL_HEIGHT)];
    self.contextLabel.backgroundColor = [UIColor clearColor];
    self.contextLabel.textColor = [EVColor inputTextColor];
    self.contextLabel.font = [EVFont blackFontOfSize:15];
    self.contextLabel.text = @"Send me notifications via...";
    [self.tableView addSubview:self.contextLabel];
}

- (void)loadForm {
    self.form = [[EVFormView alloc] initWithFrame:CGRectMake(FORM_CELL_SIDE_MARGIN,
                                                             FORM_Y_ORIGIN,
                                                             self.view.frame.size.width - FORM_CELL_SIDE_MARGIN*2,
                                                             3*FORM_ROW_HEIGHT)];
    [self.tableView addSubview:self.form];
}

- (void)loadRows {
    EVFormRow *row = nil;
    CGRect rect = CGRectMake(0, 0, self.form.frame.size.width - FORM_MARGIN*2, FORM_ROW_HEIGHT);
    NSMutableArray *array = [NSMutableArray array];
    
    row = [[EVFormRow alloc] initWithFrame:rect];
    row.fieldLabel.text = @"Push";
    self.pushSwitch = [[EVSwitch alloc] initWithFrame:CGRectZero];
    [self.pushSwitch addTarget:self action:@selector(pushSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    self.pushSwitch.on = self.setting.push;
    row.contentView = self.pushSwitch;
    [array addObject:row];
    
    row = [[EVFormRow alloc] initWithFrame:rect];
    row.fieldLabel.text = @"Email";
    self.emailSwitch = [[EVSwitch alloc] initWithFrame:CGRectZero];
    [self.emailSwitch addTarget:self action:@selector(emailSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    self.emailSwitch.on = self.setting.email;
    row.contentView = self.emailSwitch;
    [array addObject:row];
    
    row = [[EVFormRow alloc] initWithFrame:rect];
    row.fieldLabel.text = @"SMS";
    self.smsSwitch = [[EVSwitch alloc] initWithFrame:CGRectZero];
    [self.smsSwitch addTarget:self action:@selector(smsSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    self.smsSwitch.on = self.setting.sms;
    row.contentView = self.smsSwitch;
    [array addObject:row];
    
    [self.form setFormRows:array];
}

#pragma mark - Switches

- (void)pushSwitchChanged:(EVSwitch *)sender {
    if (sender.on != self.setting.push)
    {
        if (sender.on) {
            if (![EVPushManager acceptsPushNotifications]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push Notifications Disabled"
                                                                message:@"To receive push notifications from Evenly, go to Settings -> Notifications -> Evenly and enable alert banners.  Thanks!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            [EVUtilities registerForPushNotifications];
        }
        [self.setting setPush:sender.on];
        [self.setting updateWithSuccess:^{
            DLog(@"Success");
        } failure:^(NSError *error) {
            DLog(@"Failure: %@", error);
        }];
    }
}

- (void)emailSwitchChanged:(EVSwitch *)sender {
    if (sender.on != self.setting.email)
    {
        [self.setting setEmail:sender.on];
        [self.setting updateWithSuccess:^{
            DLog(@"Success");
        } failure:^(NSError *error) {
            DLog(@"Failure: %@", error);
        }];
    }
}

- (void)settingsDidReload:(NSNotification *)notification {
    self->_setting = [[EVSettingsManager sharedManager] notificationSetting];
    self.pushSwitch.on = self.setting.push;
    self.emailSwitch.on = self.setting.email;
    self.smsSwitch.on = self.setting.sms;
}

- (void)smsSwitchChanged:(EVSwitch *)sender {
    if (sender.on != self.setting.sms)
    {
        [self.setting setSms:sender.on];
        [self.setting updateWithSuccess:^{
            DLog(@"Success");
        } failure:^(NSError *error) {
            DLog(@"Failure: %@", error);
        }];
    }
}

@end
