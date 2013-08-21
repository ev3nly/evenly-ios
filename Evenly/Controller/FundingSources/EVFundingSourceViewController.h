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
#import "EVNavigationBarButton.h"

typedef enum {
    EVFundingSourceSectionSources,
    EVFundingSourceSectionAddNew,
    EVFundingSourceSectionCOUNT
} EVFundingSourceSection;


@interface EVFundingSourceViewController : EVModalViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) EVNavigationBarButton *editButton;

- (void)loadTableView;
- (void)updateEditButton;
- (void)showSuccessMessage;
- (void)showErrorMessage;

#pragma mark - Abstract Methods
@property (nonatomic, readonly) EVFundingSource *activeFundingSource;
@property (nonatomic, readonly) NSArray *fundingSources;
- (BOOL)isLoading;
- (void)configureAddNewCell:(EVGroupedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)goToAddNewScreenFromSelectedIndexPath:(NSIndexPath *)indexPath;

- (UIImage *)noFundingSourcesImage;
- (NSString *)noFundingSourcesAddedString;
- (NSString *)changingActiveString;
@end
