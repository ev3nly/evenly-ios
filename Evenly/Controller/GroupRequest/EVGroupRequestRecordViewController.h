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

@interface EVGroupRequestRecordViewController : EVViewController <UITableViewDelegate>

@property (nonatomic, strong) EVGroupRequestRecord *record;
@property (nonatomic, strong) EVGroupRequestRecordTableViewDataSource *dataSource;

@property (nonatomic, strong) UITableView *tableView;

- (id)initWithRecord:(EVGroupRequestRecord *)record;

@end
