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
#import "EVDashboardUserCell.h"
#import "EVGroupRequestProgressView.h"

@interface EVGroupRequestDashboardViewController ()

@property (nonatomic, strong) EVGroupRequest *groupRequest;
@property (nonatomic, strong) EVGroupRequestDashboardTableViewDataSource *dataSource;

@property (nonatomic, strong) UITableView *tableView;

- (void)loadRightBarButton;

@end

@implementation EVGroupRequestDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = groupRequest;
        self.dataSource = [[EVGroupRequestDashboardTableViewDataSource alloc] initWithGroupRequest:self.groupRequest];
        self.title = self.groupRequest.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadRightBarButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVDashboardTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerClass:[EVDashboardUserCell class] forCellReuseIdentifier:@"userCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)loadRightBarButton {
    UIImage *image = [UIImage imageNamed:@"More"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 20.0, image.size.height)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [button setImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button setAdjustsImageWhenHighlighted:NO];
    [button addTarget:self action:@selector(moreButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.dataSource.progressView.progressBar setProgress:0.5 animated:YES];
}

#pragma mark - Button Actions

- (void)moreButtonPress:(id)sender {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVDashboardPermanentRowTitle)
    {
        CGFloat height = [EVDashboardTitleCell heightWithTitle:self.groupRequest.title memo:self.groupRequest.memo];
        return height;
    }
    else if (indexPath.row == EVDashboardPermanentRowSegmentedControl)
    {
        return 40.0;
    }
    else if (indexPath.row == EVDashboardPermanentRowProgress)
    {
        return [EVGroupRequestProgressView height] + 20.0;
    }
    else if (indexPath.row >= EVDashboardPermanentRowCOUNT)
    {
        return 64.0;
    }
    return 44.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
