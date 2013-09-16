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
#import "EVStoryLikerCell.h"

#define LIKER_CELL_HEIGHT 44.0

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
    [self.tableView registerClass:[EVTransactionDetailCell class] forCellReuseIdentifier:@"detailCell"];
    [self.tableView registerClass:[EVStoryLikerCell class] forCellReuseIdentifier:@"likerCell"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EVStoryDetailViewControllerSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.story.loading) {
        return 0;
    }
    if (section == EVStoryDetailViewControllerSectionStory)
    {
        return 1;
    }
    else
    {
        return self.story.likes.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVStoryDetailViewControllerSectionStory)
    {
        return [EVTransactionDetailCell cellHeightForStory:self.story];
    }
    return LIKER_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EVStoryDetailViewControllerSectionStory)
    {
        EVTransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.story = self.story;
        cell.delegate = self;
        cell.position = [tableView cellPositionForIndexPath:indexPath];
        return cell;
    }
    else
    {
        EVStoryLikerCell *cell = (EVStoryLikerCell *)[tableView dequeueReusableCellWithIdentifier:@"likerCell" forIndexPath:indexPath];
        cell.liker = [self.story.likes[indexPath.row] liker];
        cell.position = [tableView cellPositionForIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == EVStoryDetailViewControllerSectionLikes)
    {
        EVUser *liker = [self.story.likes[indexPath.row] liker];
        EVProfileViewController *profileController = [[EVProfileViewController alloc] initWithUser:liker];
        [self.navigationController pushViewController:profileController animated:YES];
    }
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
