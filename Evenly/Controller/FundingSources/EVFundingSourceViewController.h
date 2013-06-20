//
//  EVFundingSourceViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVFundingSource.h"
#import "EVGroupedTableViewCell.h"

typedef enum {
    EVFundingSourceSectionSources,
    EVFundingSourceSectionAddNew,
    EVFundingSourceSectionCOUNT
} EVFundingSourceSection;


@interface EVFundingSourceViewController : EVModalViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)loadTableView;
- (void)showSuccessMessage;
- (void)showErrorMessage;

#pragma mark - Abstract Methods
@property (nonatomic, readonly) EVFundingSource *activeFundingSource;
@property (nonatomic, readonly) NSArray *fundingSources;
- (BOOL)isLoading;
- (void)configureAddNewCell:(EVGroupedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)goToAddNewScreenFromSelectedIndexPath:(NSIndexPath *)indexPath;
- (NSString *)noFundingSourcesAddedString;
- (NSString *)changingActiveString;
@end
