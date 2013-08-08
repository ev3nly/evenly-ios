//
//  EVHistoryItemViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVGrayButton.h"
#import "EVHistoryItemCell.h"
#import "EVHistoryItemUserCell.h"
#import <MessageUI/MessageUI.h>

@interface EVHistoryItemViewController : EVModalViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, EVReloadable>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) EVGrayButton *emailButton;

- (void)loadTableView;
- (void)loadFooter;
- (void)emailButtonPress:(id)sender;

- (NSString *)emailSubjectLine;

- (NSString *)fieldTextForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)valueTextForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
