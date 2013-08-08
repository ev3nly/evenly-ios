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

@interface EVHistoryItemViewController () {
    BOOL _loading;
}

@end

@implementation EVHistoryItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.canDismissManually = NO;
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
    [self.tableView setTableFooterView:self.footerView];
}

#pragma mark - TableView DataSource/Delegate

- (NSString *)fieldTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; // abstract
}

- (NSString *)valueTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; // abstract
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0; // abstract
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVHistoryItemCell heightForValueText:[self valueTextForRowAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVHistoryItemCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"EVHistoryItemCell" forIndexPath:indexPath];
    [historyCell.fieldLabel setText:[self fieldTextForRowAtIndexPath:indexPath]];
    [historyCell.valueLabel setText:[self valueTextForRowAtIndexPath:indexPath]];
    [historyCell setPosition:[tableView cellPositionForIndexPath:indexPath]];
    return historyCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; // no selection allowed
}

#pragma mark - Mail Composer Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
