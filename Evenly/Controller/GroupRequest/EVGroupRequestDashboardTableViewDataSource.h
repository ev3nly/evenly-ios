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

@class EVGroupCharge;

@interface EVGroupRequestDashboardTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) EVGroupCharge *groupCharge;

- (id)initWithGroupCharge:(EVGroupCharge *)groupCharge;

@end
