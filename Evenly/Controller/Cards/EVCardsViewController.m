//
//  EVCardsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCardsViewController.h"
#import "EVCreditCardCell.h"

@interface EVCardsViewController ()

@property (nonatomic, strong) UITableView *tableView;

- (void)loadTableView;

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
    
    [self loadTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditCardsDidUpdate:)
                                                 name:EVCIAUpdatedCreditCardsNotification
                                               object:nil];

}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EVCardsSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == EVCardsSectionCards)
    {
        if ([[EVCIA sharedInstance] loadingCreditCards])
            return 1;
        else
            return MAX(1, [[[EVCIA sharedInstance] creditCards] count]);
    }
    return EVCardsAddNewRowCOUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == EVCardsSectionCards)
    {
        
    }
    
    EVCreditCardCell *cell = (EVCreditCardCell *)[tableView dequeueReusableCellWithIdentifier:@"creditCardCell" forIndexPath:indexPath];
    
    cell.position = EVGroupTableViewCellPositionSingle;
    cell.textLabel.text = @"test";
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
    
}

#pragma mark - Notifications

- (void)creditCardsDidUpdate:(NSNotification *)notification {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
