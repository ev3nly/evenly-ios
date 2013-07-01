//
//  EVAutocompleteTableViewDataSource.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVAutocompleteTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) NSArray *filteredConnections;
@property (nonatomic, strong) NSArray *suggestions;
@property (nonatomic) CGFloat cellHeight;

- (void)setUpReactions;

- (void)handleFieldInput:(NSString *)text;

@end
