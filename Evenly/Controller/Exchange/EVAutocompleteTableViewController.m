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
#import "EVAutocompleteSearchOnServerCell.h"

#define LABEL_HEIGHT 15
#define HEADER_HEIGHT 25
#define X_MARGIN 10
#define Y_MARGIN 5

@interface EVAutocompleteTableViewController ()

@property (nonatomic, strong) UIView *evenlyFriendsHeaderView;
@property (nonatomic, strong) EVSpreadLabel *evenlyFriendsHeaderLabel;

@property (nonatomic, strong) UIView *contactsHeaderView;
@property (nonatomic, strong) EVSpreadLabel *contactsLabel;

@property (nonatomic, strong) UIView *searchHeaderView;
@property (nonatomic, strong) EVSpreadLabel *searchLabel;

@property (nonatomic, strong) EVAutocompleteSearchOnServerCell *searchOnServerCell;

- (void)loadHeaderViews;
- (void)parseSearchResult:(id)result;

@end

@implementation EVAutocompleteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.cellHeight = 45.0;
        self.filteredConnections = [EVCIA myConnections];
        self.addressBookSuggestions = [ABContactsHelper autocompletableContacts];
        self.serverSearchSuggestions = [NSArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateMe:)
                                                     name:EVCIAUpdatedMeNotification
                                                   object:nil];
        
        [self loadSearchOnServerCell];
        
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

- (void)loadSearchOnServerCell {
    self.searchOnServerCell = [[EVAutocompleteSearchOnServerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    
}

- (void)loadHeaderViews {
    EVSpreadLabel *spreadLabel;
    UIView *headerView;
    UIView *bottomStripe;
    
    spreadLabel = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, self.tableView.frame.size.width - 2*X_MARGIN, LABEL_HEIGHT)];
    spreadLabel.backgroundColor = [UIColor clearColor];
    spreadLabel.textColor = [EVColor lightLabelColor];
    spreadLabel.font = [EVFont blackFontOfSize:11];
    spreadLabel.characterSpacing = 2.0;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [EVColor requestGrayBackground];
    [headerView addSubview:spreadLabel];
    
    bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - [EVUtilities scaledDividerHeight], headerView.frame.size.width, [EVUtilities scaledDividerHeight])];
    bottomStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [headerView addSubview:bottomStripe];
    
    self.evenlyFriendsHeaderLabel = spreadLabel;
    self.evenlyFriendsHeaderLabel.text = @"EVENLY FRIENDS";
    self.evenlyFriendsHeaderView = headerView;
    
    spreadLabel = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, self.tableView.frame.size.width - 2*X_MARGIN, LABEL_HEIGHT)];
    spreadLabel.backgroundColor = [UIColor clearColor];
    spreadLabel.textColor = [EVColor lightLabelColor];
    spreadLabel.font = [EVFont blackFontOfSize:11];
    spreadLabel.characterSpacing = 2.0;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [EVColor requestGrayBackground];
    [headerView addSubview:spreadLabel];
    
    bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - [EVUtilities scaledDividerHeight], headerView.frame.size.width, [EVUtilities scaledDividerHeight])];
    bottomStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [headerView addSubview:bottomStripe];
    
    self.contactsLabel = spreadLabel;
    self.contactsLabel.text = @"CONTACTS";
    self.contactsHeaderView = headerView;
    
    spreadLabel = [[EVSpreadLabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, self.tableView.frame.size.width - 20, LABEL_HEIGHT)];
    spreadLabel.backgroundColor = [UIColor clearColor];
    spreadLabel.textColor = [EVColor lightLabelColor];
    spreadLabel.font = [EVFont blackFontOfSize:11];
    spreadLabel.characterSpacing = 2.0;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [EVColor requestGrayBackground];
    [headerView addSubview:spreadLabel];
    
    bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - [EVUtilities scaledDividerHeight], headerView.frame.size.width, [EVUtilities scaledDividerHeight])];
    bottomStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [headerView addSubview:bottomStripe];
    
    self.searchLabel = spreadLabel;
    self.searchLabel.text = @"SEARCH";
    self.searchHeaderView = headerView;
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
    if ([self.serverSearchSuggestions count]) {
        self.serverSearchSuggestions = @[];
    }
    [self.searchOnServerCell setSearchQuery:text];
    EV_PERFORM_ON_BACKGROUND_QUEUE(^{
        if (!EV_IS_EMPTY_STRING(text)) {
            [self filterConnectionsWithText:text];
            self.addressBookSuggestions = [ABContactsHelper autocompletableContactsMatchingName:text];
        }
        else {
            self.filteredConnections = [EVCIA myConnections];
            self.addressBookSuggestions = [ABContactsHelper autocompletableContacts];
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

- (void)parseSearchResult:(id)result {
    DLog(@"Result: %@", result);
    self.serverSearchSuggestions = result;
    if (self.serverSearchSuggestions.count)
        [self reloadSection:EVAutocompleteSectionSearchOnServer];
    else
        [self.searchOnServerCell setShowingNoResults:YES];
}

- (void)reloadSection:(NSInteger)sectionIndex {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EVAutocompleteSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == EVAutocompleteSectionConnections)
        count = self.filteredConnections.count;
    else if (section == EVAutocompleteSectionAddressBook)
        count = self.addressBookSuggestions.count;
    else
        count = (self.serverSearchSuggestions.count ?: 1);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (id)contactAtIndexPath:(NSIndexPath *)indexPath {
    id contact = nil;
    if (indexPath.section == EVAutocompleteSectionConnections && [self.filteredConnections count] > indexPath.row)
        contact = [self.filteredConnections objectAtIndex:indexPath.row];
    else if (indexPath.section == EVAutocompleteSectionAddressBook && [self.addressBookSuggestions count] > indexPath.row)
        contact = [self.addressBookSuggestions objectAtIndex:indexPath.row];
    else if (indexPath.section == EVAutocompleteSectionSearchOnServer && [self.serverSearchSuggestions count] > indexPath.row)
        contact = [self.serverSearchSuggestions objectAtIndex:indexPath.row];
    return contact;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id contact = [self contactAtIndexPath:indexPath];
    if (indexPath.section == EVAutocompleteSectionConnections)
    {
        cell = [self photoCellForContactAtIndexPath:indexPath];
    }
    else if (indexPath.section == EVAutocompleteSectionAddressBook)
    {
        EVAutocompleteEmailCell *emailCell = [tableView dequeueReusableCellWithIdentifier:@"emailCell" forIndexPath:indexPath];
        ABContact *abContact = contact;
        emailCell.nameLabel.text = [abContact compositeName];
        emailCell.emailLabel.text = [abContact evenlyContactString];
        cell = emailCell;
    }
    else if (indexPath.section == EVAutocompleteSectionSearchOnServer)
    {
        if (indexPath.row == [self.serverSearchSuggestions count])
        {
            return self.searchOnServerCell;
        }
        else
        {
            cell = [self photoCellForContactAtIndexPath:indexPath];
        }
    }
    return cell;
}

- (EVAutocompletePhotoCell *)photoCellForContactAtIndexPath:(NSIndexPath *)indexPath {
    id contact = [self contactAtIndexPath:indexPath];
    EVAutocompletePhotoCell *photoCell = [self.tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    if ([contact conformsToProtocol:@protocol(EVAvatarOwning)])
        [photoCell.avatarView setAvatarOwner:(NSObject<EVAvatarOwning> *)contact];
    
    if ([contact respondsToSelector:@selector(name)]) {
        [photoCell.label setText:[contact name]];
    }
    else if ([contact isKindOfClass:[ABContact class]]) {
        ABContact *abContact = contact;
        photoCell.label.text = [NSString stringWithFormat:@"%@ %@", abContact.firstname, abContact.lastname];
    }
    return photoCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath] == self.searchOnServerCell) {
        if (self.inputField.text.length > 2 && [self.serverSearchSuggestions count] == 0)
            return indexPath;
        else
            return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath] == self.searchOnServerCell) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.searchOnServerCell setLoading:YES];
        [EVUser allWithParams:@{ @"query" : self.inputField.text }
                      success:^(id result) {
                          [self parseSearchResult:result];
                          [self.searchOnServerCell setLoading:NO];
                      } failure:^(NSError *error) {
                          DLog(@"Error searching: %@", error);
                          [self.searchOnServerCell setLoading:NO];
                      }];
        return;
    }
    
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
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == EVAutocompleteSectionConnections)
        view = self.evenlyFriendsHeaderView;
    else if (section == EVAutocompleteSectionAddressBook)
        view = self.contactsHeaderView;
    else if (section == EVAutocompleteSectionSearchOnServer)
        view = self.searchHeaderView;
    return view;    
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
