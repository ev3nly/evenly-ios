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

@property (nonatomic, strong) UIView *evenlyFriendsHeaderView;
@property (nonatomic, strong) EVSpreadLabel *evenlyFriendsHeaderLabel;

@property (nonatomic, strong) UIView *contactsHeaderView;
@property (nonatomic, strong) EVSpreadLabel *contactsLabel;

- (void)loadHeaderViews;

@end

@implementation EVAutocompleteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.cellHeight = 45.0;
        self.filteredConnections = [EVCIA myConnections];
        self.addressBookSuggestions = [ABContactsHelper contactsWithEmail];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateMe:)
                                                     name:EVCIAUpdatedMeNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVAutocompletePhotoCell class]
           forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerClass:[EVAutocompleteEmailCell class]
           forCellReuseIdentifier:@"emailCell"];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadHeaderViews];
}

- (void)loadHeaderViews {
    EVSpreadLabel *spreadLabel;
    UIView *headerView;
    UIView *bottomStripe;
    
    spreadLabel = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width - 20, 15)];
    spreadLabel.backgroundColor = [UIColor clearColor];
    spreadLabel.textColor = [EVColor lightLabelColor];
    spreadLabel.font = [EVFont blackFontOfSize:11];
    spreadLabel.characterSpacing = 2.0;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    headerView.backgroundColor = [EVColor requestGrayBackground];
    [headerView addSubview:spreadLabel];
    
    bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, headerView.frame.size.width, 1)];
    bottomStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [headerView addSubview:bottomStripe];
    
    self.evenlyFriendsHeaderLabel = spreadLabel;
    self.evenlyFriendsHeaderLabel.text = @"EVENLY FRIENDS";
    self.evenlyFriendsHeaderView = headerView;
    
    spreadLabel = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width - 20, 15)];
    spreadLabel.backgroundColor = [UIColor clearColor];
    spreadLabel.textColor = [EVColor lightLabelColor];
    spreadLabel.font = [EVFont blackFontOfSize:11];
    spreadLabel.characterSpacing = 2.0;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    headerView.backgroundColor = [EVColor requestGrayBackground];
    [headerView addSubview:spreadLabel];
    
    bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, headerView.frame.size.width, 1)];
    bottomStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [headerView addSubview:bottomStripe];
    
    self.contactsLabel = spreadLabel;
    self.contactsLabel.text = @"CONTACTS";
    self.contactsHeaderView = headerView;
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
    EV_PERFORM_ON_BACKGROUND_QUEUE(^{
        if (!EV_IS_EMPTY_STRING(text)) {
            [self filterConnectionsWithText:text];
            self.addressBookSuggestions = [ABContactsHelper contactsWithEmailMatchingName:text];
        }
        else {
            self.filteredConnections = [EVCIA myConnections];
            self.addressBookSuggestions = [ABContactsHelper contactsWithEmail];
        }
        EV_PERFORM_ON_MAIN_QUEUE(^{
            [self.tableView reloadData];
        });
    });
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
    if (section == EVAutocompleteSectionConnections)
        count = MIN(self.filteredConnections.count, EV_AUTOCOMPLETE_MAX_CONNECTIONS_SHOWN);
    else
        count = self.addressBookSuggestions.count;
    DLog(@"%d rows in section %d", count, section);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (id)contactAtIndexPath:(NSIndexPath *)indexPath {
    id contact = nil;
    if (indexPath.section == EVAutocompleteSectionConnections && [self.filteredConnections count] > indexPath.row)
        contact = [self.filteredConnections objectAtIndex:indexPath.row];
    else if ([self.addressBookSuggestions count] > indexPath.row)
        contact = [self.addressBookSuggestions objectAtIndex:indexPath.row];
    return contact;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id contact = [self contactAtIndexPath:indexPath];
    if (indexPath.section == EVAutocompleteSectionConnections)
    {
        EVAutocompletePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        [photoCell.avatarView setAvatarOwner:(NSObject<EVAvatarOwning> *)contact];
        [photoCell.label setText:[contact name]];
        cell = photoCell;
    }
    else
    {
        EVAutocompleteEmailCell *emailCell = [tableView dequeueReusableCellWithIdentifier:@"emailCell" forIndexPath:indexPath];
        emailCell.nameLabel.text = [contact compositeName];
        emailCell.emailLabel.text = [[contact emailArray] objectAtIndex:0];
        cell = emailCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EV_DISPATCH_AFTER(0.5, ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    id contact = [self contactAtIndexPath:indexPath];
    if (self.delegate)
        [self.delegate autocompleteViewController:self didSelectContact:contact];
    [self handleFieldInput:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == EVAutocompleteSectionConnections && self.filteredConnections.count == 0)
        return 0.0;
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == EVAutocompleteSectionConnections)
        return self.evenlyFriendsHeaderView;
    else
        return self.contactsHeaderView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.inputField resignFirstResponder];
    }
}

#pragma mark - Notifications

- (void)didUpdateMe:(NSNotification *)notification {
    [self filterConnectionsWithText:self.inputField.text];
    [self.tableView reloadData];
}

@end
