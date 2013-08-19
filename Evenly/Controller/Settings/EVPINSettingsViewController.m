//
//  EVPINSettingsViewController.m
//  Evenly
//
//  Created by Justin Brunet on 8/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPINSettingsViewController.h"
#import "EVSetPINViewController.h"
#import "EVGroupedTableViewCell.h"
#import "EVSwitch.h"

#define PIN_ENABLE_VIEW_SIDE_BUFFER 20
#define PIN_ENABLE_VIEW_TOP_BUFFER 20
#define PIN_CELL_HEIGHT 50

@interface EVPINSettingsViewController ()

@property (nonatomic, strong) UIView *enableView;
@property (nonatomic, strong) EVSwitch *enableSwitch;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic,

@end

@implementation EVPINSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"PIN";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self loadTableView];
    [self loadEnableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.enableSwitch.on = [[EVPINUtility sharedUtility] pinIsSet];
    [self.tableView reloadData];
}

- (void)loadEnableView {
    self.enableView = [[UIView alloc] initWithFrame:[self enableViewFrame]];
    [self loadEnableLabel];
    [self loadEnableSwitch];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"groupedCell"];
    [self.view addSubview:self.tableView];
}

- (void)loadEnableLabel {
    UILabel *enableLabel = [UILabel new];
    enableLabel.backgroundColor = [UIColor clearColor];
    enableLabel.text = @"Enable PIN";
    enableLabel.textColor = [EVColor mediumLabelColor];
    enableLabel.font = [EVFont blackFontOfSize:15];
    [self.enableView addSubview:enableLabel];
    
    [enableLabel sizeToFit];
    [enableLabel setOrigin:CGPointMake(0, CGRectGetMidY(self.enableView.bounds) - enableLabel.bounds.size.height/2)];
}

- (void)loadEnableSwitch {
    self.enableSwitch = [EVSwitch new];
    [self.enableSwitch addTarget:self action:@selector(switchTapped:) forControlEvents:UIControlEventValueChanged];
    [self.enableView addSubview:self.enableSwitch];
    [self.enableSwitch setOrigin:CGPointMake(self.enableView.bounds.size.width - self.enableSwitch.bounds.size.width,
                                        CGRectGetMidY(self.enableView.bounds) - self.enableSwitch.bounds.size.height/2)];
    self.enableSwitch.on = [[EVPINUtility sharedUtility] pinIsSet];
}

- (void)switchTapped:(EVSwitch *)sender {
    if (!sender.isOn) {
        [[EVPINUtility sharedUtility] clearStoredPIN];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        EVSetPINViewController *pinController = [EVSetPINViewController new];
        pinController.needsToEnterOldPIN = NO;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinController];
        [self presentViewController:navController animated:YES completion:^{
            [self.tableView reloadData];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.enableSwitch.isOn)
        return 1;
    return EVPINSettingCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PIN_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell = (EVGroupedTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"groupedCell" forIndexPath:indexPath];
    
    if (indexPath.row == EVPINSettingEnable) {
        [cell addSubview:self.enableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textLabel.text = @"Change PIN";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVSetPINViewController *pinController = [[EVSetPINViewController alloc] initWithNibName:nil bundle:nil];
    pinController.needsToEnterOldPIN = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (CGRect)enableViewFrame {
    return CGRectMake(PIN_ENABLE_VIEW_SIDE_BUFFER,
                      0,
                      self.view.bounds.size.width - PIN_ENABLE_VIEW_SIDE_BUFFER*2,
                      PIN_CELL_HEIGHT);
}

- (CGRect)tableViewFrame {
    return self.view.bounds;
}

@end
