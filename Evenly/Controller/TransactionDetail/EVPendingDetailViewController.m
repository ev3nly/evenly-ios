//
//  EVPendingDetailViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingDetailViewController.h"
#import "EVPendingDetailCell.h"

@interface EVPendingDetailViewController ()

@end

@implementation EVPendingDetailViewController

#pragma mark - Lifecycle

- (id)initWithStory:(EVStory *)story {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.story = story;
        self.title = @"Transaction";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    [self.tableView registerClass:[EVPendingDetailCell class] forCellReuseIdentifier:@"pendingDetailCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVPendingDetailCell cellHeightForStory:self.story];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVPendingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pendingDetailCell" forIndexPath:indexPath];
    cell.story = self.story;
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
