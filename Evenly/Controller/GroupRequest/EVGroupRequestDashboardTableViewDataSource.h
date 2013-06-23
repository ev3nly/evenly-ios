//
//  EVGroupRequestDashboardTableViewDataSource.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EVDashboardPermanentRowTitle,
    EVDashboardPermanentRowProgress,
    EVDashboardPermanentRowSegmentedControl,
    EVDashboardPermanentRowCOUNT
} EVDashboardPermanentRow;

@class EVGroupRequest;
@class EVGroupRequestProgressView;
@class EVSegmentedControl;

@interface EVGroupRequestDashboardTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) EVGroupRequest *groupRequest;
@property (nonatomic, strong) EVGroupRequestProgressView *progressView;
@property (nonatomic, strong) EVSegmentedControl *segmentedControl;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

@end
