//
//  EVAutocompleteTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompleteTableViewDataSource.h"
#import "EVUserAutocompletionCell.h"
#import "ABContactsHelper.h"
#import "EVSpreadLabel.h"

@interface EVAutocompleteTableViewDataSource ()

@property (nonatomic, strong) UIView *contactsHeaderView;
@property (nonatomic, strong) EVSpreadLabel *contactsLabel;

@end

@implementation EVAutocompleteTableViewDataSource

- (id)init {
    self = [super init];
    if (self) {
        self.cellHeight = 40;
        self.filteredConnections = [EVCIA myConnections];
    }
    return self;
}

- (void)setUpReactions {
    [self.textField.rac_textSignal subscribeNext:^(NSString *toString) {
        [self handleFieldInput:toString];
    }];
}

- (void)handleFieldInput:(NSString *)text {
    if ([self.textField isFirstResponder]) {
        [self filterConnectionsWithText:text];
        self.suggestions = [ABContactsHelper contactsWithEmailMatchingName:text];
    }
    else {
        self.filteredConnections = [EVCIA myConnections];
        self.suggestions = [NSArray array];
    }
    [self reloadTableView];
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

- (void)reloadTableView {
    EV_PERFORM_ON_MAIN_QUEUE(^ (void) {
        if (![self.textField isFirstResponder]) {
            [self.tableView setHidden:YES];
            return;
        }
        [self.tableView setHidden:(self.suggestions.count == 0)];
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0)
        count = self.filteredConnections.count;
    else
        count = self.suggestions.count;
    DLog(@"%d rows in section %d", count, section);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVUserAutocompletionCell *cell = (EVUserAutocompletionCell *)[tableView dequeueReusableCellWithIdentifier:@"userAutocomplete"];
    id contact;
    if (indexPath.section == 0)
        contact = [self.filteredConnections objectAtIndex:indexPath.row];
    else
        contact = [self.suggestions objectAtIndex:indexPath.row];
    if ([contact isKindOfClass:[EVUser class]]) {
        cell.nameLabel.text = [contact name];
        cell.emailLabel.text = [contact email];
    }
    else if ([contact isKindOfClass:[ABContact class]]) {
        cell.nameLabel.text = [contact compositeName];
        cell.emailLabel.text = [[contact emailArray] objectAtIndex:0];
    }
    
    return cell;
}


@end
