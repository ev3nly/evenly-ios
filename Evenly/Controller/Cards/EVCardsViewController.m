//
//  EVCardsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCardsViewController.h"
#import "EVGroupTableViewCell.h"

@interface EVCardsViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EVCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [EVColor newsfeedStripeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupTableViewCell *cell = (EVGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[EVGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    EVGroupTableViewCellBackground *background = (EVGroupTableViewCellBackground *)cell.backgroundView;
    background.position = (EVGroupTableViewCellPosition)indexPath.row;
    
//    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[EVImages resizableTombstoneBackground]];
//    [backgroundView setFrame:cell.bounds];
//    [cell setBackgroundView:backgroundView];
    
    cell.textLabel.text = @"test";
    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
