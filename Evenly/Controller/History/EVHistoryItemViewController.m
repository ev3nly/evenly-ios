//
//  EVHistoryItemViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryItemViewController.h"

#define X_MARGIN 10.0
#define FOOTER_Y_MARGIN 5.0

#define LABEL_HEIGHT 40.0
#define BUTTON_HEIGHT 35.0

@interface EVHistoryItemViewController ()

@end

@implementation EVHistoryItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    [self loadFooter];
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
    
    [self.tableView registerClass:[EVHistoryItemCell class] forCellReuseIdentifier:@"EVHistoryItemCell"];
    [self.tableView registerClass:[EVHistoryItemUserCell class] forCellReuseIdentifier:@"EVHistoryItemUserCell"];    
}

- (void)loadFooter {
    self.footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN,
                                                                 FOOTER_Y_MARGIN,
                                                                 self.view.frame.size.width - 2*X_MARGIN,
                                                                 LABEL_HEIGHT)];
    self.footerLabel.font = [EVFont defaultFontOfSize:15];
    self.footerLabel.backgroundColor = [UIColor clearColor];
    self.footerLabel.textColor = [EVColor lightLabelColor];
    self.footerLabel.numberOfLines = 2;
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    self.footerLabel.text = @"Does something look off?\nDo you have questions?";
    
    self.emailButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(X_MARGIN,
                                                                      CGRectGetMaxY(self.footerLabel.frame) + FOOTER_Y_MARGIN,
                                                                      self.view.frame.size.width - 2*X_MARGIN,
                                                                      BUTTON_HEIGHT)];
    [self.emailButton setTitle:@"EMAIL OUR SUPPORT TEAM" forState:UIControlStateNormal];
    [self.emailButton addTarget:self action:@selector(emailButtonPress:) forControlEvents:UIControlEventTouchUpInside];

    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, CGRectGetMaxY(self.emailButton.frame) + FOOTER_Y_MARGIN)];
    [self.footerView addSubview:self.footerLabel];
    [self.footerView addSubview:self.emailButton];
    
    [self.tableView setTableFooterView:self.footerView];
}

- (void)emailButtonPress:(id)sender {
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    [composer setSubject:[self emailSubjectLine]];
    [composer setToRecipients:@[ [EVStringUtility supportEmail] ]];
    [self presentViewController:composer animated:YES completion:NULL];
}

- (NSString *)emailSubjectLine {
    return @""; // abstract
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0; // abstract
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f; // abstract
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; // abstract
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; // no selection allowed
}

#pragma mark - Mail Composer Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
