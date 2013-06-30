//
//  EVGroupRequestRecordViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVGroupRequestRecordTableViewDataSource.h"

@class EVGroupRequestRecord;
@class EVGroupRequestRecordViewController;

@protocol EVGroupRequestRecordViewControllerDelegate <NSObject>

- (void)viewController:(EVGroupRequestRecordViewController *)viewController updatedRecord:(EVGroupRequestRecord *)record;

@end

@interface EVGroupRequestRecordViewController : EVViewController <UITableViewDelegate>

@property (nonatomic, weak) id<EVGroupRequestRecordViewControllerDelegate> delegate;
@property (nonatomic, strong) EVGroupRequestRecord *record;
@property (nonatomic, strong) EVGroupRequestRecordTableViewDataSource *dataSource;

@property (nonatomic, strong) UITableView *tableView;

- (id)initWithRecord:(EVGroupRequestRecord *)record;

@end
