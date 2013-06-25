//
//  EVGropuRequestRecordTableViewDataSource.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVGroupRequestRecord.h"

@interface EVGroupRequestRecordTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) EVGroupRequestRecord *record;
@property (nonatomic, weak) UITableView *tableView;

- (id)initWithRecord:(EVGroupRequestRecord *)record;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
