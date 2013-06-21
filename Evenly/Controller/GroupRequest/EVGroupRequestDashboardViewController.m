//
//  EVGroupRequestDashboardViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestDashboardViewController.h"
#import "EVGroupRequestDashboardTableViewDataSource.h"
#import "EVDashboardTitleCell.h"

@interface EVGroupRequestDashboardViewController ()

@property (nonatomic, strong) EVGroupCharge *groupCharge;
@property (nonatomic, strong) EVGroupRequestDashboardTableViewDataSource *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EVGroupRequestDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithGroupCharge:(EVGroupCharge *)groupCharge {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupCharge = groupCharge;
        self.dataSource = [[EVGroupRequestDashboardTableViewDataSource alloc] initWithGroupCharge:self.groupCharge];
        self.title = self.groupCharge.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVDashboardTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
