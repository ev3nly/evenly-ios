//
//  EVAutocompleteTableViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EVAutocompleteSectionConnections,
    EVAutocompleteSectionAddressBook
} EVAutocompleteSection;

@class EVAutocompleteTableViewController;

@protocol EVAutocompleteTableViewControllerDelegate <NSObject>

- (void)autocompleteViewController:(EVAutocompleteTableViewController *)viewController didSelectContact:(id)contact;

@end

@interface EVAutocompleteTableViewController : UITableViewController

@property (nonatomic, weak) id<EVAutocompleteTableViewControllerDelegate> delegate;
@property (nonatomic, weak) UITextField *inputField;

@property (nonatomic, strong) NSArray *filteredConnections;
@property (nonatomic, strong) NSArray *addressBookSuggestions;
@property (nonatomic) CGFloat cellHeight;

- (void)handleFieldInput:(NSString *)text;

@end
