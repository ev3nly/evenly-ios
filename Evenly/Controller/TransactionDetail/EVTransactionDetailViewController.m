//
//  EVTransactionDetailViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTransactionDetailViewController.h"
#import "EVProfileViewController.h"
#import "EVStory.h"

@interface EVTransactionDetailViewController ()

@end

@implementation EVTransactionDetailViewController

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
    [self.tableView registerClass:[EVTransactionDetailCell class] forCellReuseIdentifier:@"detailCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Button Handling

- (void)avatarTappedForUser:(EVUser *)user {

    EVProfileViewController *profileController = [[EVProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:profileController animated:YES];
    return;
    [EVUser loadUser:user withSuccess:^{
        EVProfileViewController *profileController = [[EVProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:profileController animated:YES];

    } failure:^(NSError *error) {
        NSLog(@"failed arg");
    }];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVTransactionDetailCell cellHeightForStory:self.story];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVTransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    cell.story = self.story;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
