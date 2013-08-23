//
//  EVStoryDetailViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryDetailViewController.h"
#import "EVProfileViewController.h"
#import "EVStory.h"

@interface EVStoryDetailViewController () {
    BOOL _loading;
}

@end

@implementation EVStoryDetailViewController

#pragma mark - Lifecycle

- (id)initWithStory:(EVStory *)story {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.story = story;
        self.title = @"Transaction";
        self.canDismissManually = NO;
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
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    self.tableView.backgroundView = nil;
//    self.tableView.contentInset = UIEdgeInsetsMake([self totalBarHeight], 0, 0, 0);
    [self.tableView registerClass:[EVTransactionDetailCell class] forCellReuseIdentifier:@"detailCell"];
    self.tableView.contentOffset = CGPointZero;
    [self.view addSubview:self.tableView];
    
    [self.tableView setLoading:self.story.loading];
}

#pragma mark - Button Handling

- (void)avatarTappedForUser:(EVUser *)user {
    if (!user.dbid)
        return;
    EVProfileViewController *profileController = [[EVProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:profileController animated:YES];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.story.loading) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = (int)[EVTransactionDetailCell cellHeightForStory:self.story];
    if ((int)height % 2 != 0)
        height += 1; //the grouped cells don't play nice with odd heights
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVTransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.story = self.story;
    cell.delegate = self;
    cell.position = [tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EVReloadable

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [self.tableView setLoading:_loading];
}

- (BOOL)isLoading {
    return _loading;
}

- (void)reload {
    [self.tableView reloadData];
    [self.tableView setLoading:NO];
}

@end
