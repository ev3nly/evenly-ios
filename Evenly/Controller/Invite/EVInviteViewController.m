//
//  EVInviteViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteViewController.h"
#import "EVGroupedTableViewCell.h"
#import "EVFacebookInviteViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#define CELL_HEIGHT 54

@interface EVInviteViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation EVInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Invite";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    [self loadTextField];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"groupedTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)loadTextField {
    self.textField = [UITextField new];
    self.textField.text = @"";
    self.textField.textColor = [EVColor darkLabelColor];
    self.textField.font = [EVFont boldFontOfSize:15];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.placeholder = @"Enter Email";
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVInviteMethodCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"groupedTableViewCell"];
    
    if (indexPath.row != EVInviteMethodEmail) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
        cell.textLabel.text = indexPath.row == EVInviteMethodFacebook ? @"Invite From Facebook" : @"Invite From Contacts";
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.textField];
        self.textField.frame = [self textFieldFrame];
    }
    cell.position = [self cellPositionForIndexPath:indexPath];
    return cell;
}

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (rowCount <= 1)
        return EVGroupedTableViewCellPositionSingle;
    else {
        if (indexPath.row == 0)
            return EVGroupedTableViewCellPositionTop;
        else if (indexPath.row == rowCount - 1)
            return EVGroupedTableViewCellPositionBottom;
        else
            return EVGroupedTableViewCellPositionCenter;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == EVInviteMethodFacebook) {
        EVFacebookInviteViewController *facebookInviteController = [[EVFacebookInviteViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:facebookInviteController animated:YES];
    }
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return self.view.bounds;
}

- (CGRect)textFieldFrame {
    return CGRectMake(20,
                      0,
                      self.view.bounds.size.width - 20*2,
                      CELL_HEIGHT);
}

@end
