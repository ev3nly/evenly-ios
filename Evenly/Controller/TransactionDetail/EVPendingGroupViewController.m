//
//  EVPendingGroupViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingGroupViewController.h"
#import "EVTransactionDetailCell.h"
#import "EVGroupedTableViewCell.h"

@interface EVPendingGroupViewController ()

@end

@implementation EVPendingGroupViewController

- (id)initWithGroupRequest:(EVGroupRequest *)request {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = request;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVTransactionDetailCell class] forCellReuseIdentifier:@"transactionCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Public Interface


- (void)payInFull {
    
}

- (void)payPartial {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [EVTransactionDetailCell cellHeightForStory:[EVStory storyFromGroupRequest:self.groupRequest]];
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        EVTransactionDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
        EVStory *story = [EVStory storyFromGroupRequest:self.groupRequest];
        [detailCell setStory:story];
        cell = detailCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    return cell;
}

@end
