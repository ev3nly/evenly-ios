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

@interface EVAutocompleteTableViewDataSource ()

@end

@implementation EVAutocompleteTableViewDataSource

- (id)init {
    self = [super init];
    if (self) {
        self.cellHeight = 40;
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
        self.suggestions = [ABContactsHelper contactsWithEmailMatchingName:text];
        [self reloadTableView];
        
        if (!EV_IS_EMPTY_STRING(text)) {
            [EVUser allWithParams:@{ @"query" : text } success:^(id result) {
                self.suggestions = [self.suggestions arrayByAddingObjectsFromArray:(NSArray *)result];
                [self reloadTableView];
            } failure:^(NSError *error) {
                DLog(@"error: %@", error);
            }];
        }
    }
    else {
        [self.tableView setHidden:YES];
        self.suggestions = [NSArray array];
    }
//    if (!self.exchange.to)
//        self.exchange.to = [EVUser new];
//    self.exchange.to.email = text;
//    self.exchange.to.dbid = nil;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.suggestions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVUserAutocompletionCell *cell = (EVUserAutocompletionCell *)[tableView dequeueReusableCellWithIdentifier:@"userAutocomplete"];
    
    id contact = [self.suggestions objectAtIndex:indexPath.row];
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
