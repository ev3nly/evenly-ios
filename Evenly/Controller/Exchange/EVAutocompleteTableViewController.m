//
//  EVAutocompleteTableViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompleteTableViewController.h"
#import "ABContactsHelper.h"
#import "EVSpreadLabel.h"

#import "EVAutocompletePhotoCell.h"
#import "EVAutocompleteEmailCell.h"

@interface EVAutocompleteTableViewController ()

@property (nonatomic, strong) UIView *contactsHeaderView;
@property (nonatomic, strong) EVSpreadLabel *contactsLabel;

@end

@implementation EVAutocompleteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.cellHeight = 45.0;
        self.filteredConnections = [EVCIA myConnections];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVAutocompletePhotoCell class]
           forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerClass:[EVAutocompleteEmailCell class]
           forCellReuseIdentifier:@"emailCell"];
    
    self.tableView.separatorColor = [EVColor newsfeedStripeColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInputField:(UITextField *)inputField {
    _inputField = inputField;
    [self.inputField.rac_textSignal subscribeNext:^(NSString *text) {
        [self handleFieldInput:text];
    }];
}

- (void)handleFieldInput:(NSString *)text {
    if (!EV_IS_EMPTY_STRING(text)) {
        [self filterConnectionsWithText:text];
        self.addressBookSuggestions = [ABContactsHelper contactsWithEmailMatchingName:text];
    }
    else {
        self.filteredConnections = [EVCIA myConnections];
        self.addressBookSuggestions = [NSArray array];
    }
    [self.tableView reloadData];
}

- (void)filterConnectionsWithText:(NSString *)text {
    if (EV_IS_EMPTY_STRING(text))
    {
        self.filteredConnections = [EVCIA myConnections];
        return;
    }
    
    NSArray *contacts = [[EVCIA myConnections] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *name = [evaluatedObject name];
        NSArray *nameWords = [name componentsSeparatedByString:@" "];
        BOOL include = NO;
        for (NSString *word in nameWords) {
            BOOL hasPrefix = [word hasPrefix:text];
            include = include || hasPrefix;
        }
        return include;
    }]];
    self.filteredConnections = contacts;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0)
        count = self.filteredConnections.count;
    else
        count = self.addressBookSuggestions.count;
    DLog(@"%d rows in section %d", count, section);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id contact;
    if (indexPath.section == EVAutocompleteSectionConnections)
    {
        contact = [self.filteredConnections objectAtIndex:indexPath.row];
        EVAutocompletePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        [photoCell.avatarView setAvatarOwner:(NSObject<EVAvatarOwning> *)contact];
        [photoCell.label setText:[contact name]];
        cell = photoCell;
    }
    else
    {
        contact = [self.addressBookSuggestions objectAtIndex:indexPath.row];
        EVAutocompleteEmailCell *emailCell = [tableView dequeueReusableCellWithIdentifier:@"emailCell" forIndexPath:indexPath];
        emailCell.nameLabel.text = [contact compositeName];
        emailCell.emailLabel.text = [[contact emailArray] objectAtIndex:0];
        cell = emailCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id contact = nil;
    if (indexPath.section == 0)
        contact = [self.filteredConnections objectAtIndex:indexPath.row];
    else
        contact = [self.addressBookSuggestions objectAtIndex:indexPath.row];
    if (self.delegate)
        [self.delegate autocompleteViewController:self didSelectContact:contact];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0.0;
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return nil;
    if (!self.contactsHeaderView)
    {
        self.contactsLabel = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width - 20, 15)];
        self.contactsLabel.backgroundColor = [UIColor clearColor];
        self.contactsLabel.textColor = [EVColor lightLabelColor];
        self.contactsLabel.font = [EVFont blackFontOfSize:11];
        self.contactsLabel.characterSpacing = 2.0;
        self.contactsLabel.text = @"CONTACTS";
        
        self.contactsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
        self.contactsHeaderView.backgroundColor = [EVColor requestGrayBackground];
        [self.contactsHeaderView addSubview:self.contactsLabel];
    }
    return self.contactsHeaderView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.inputField resignFirstResponder];
    }
}

@end
