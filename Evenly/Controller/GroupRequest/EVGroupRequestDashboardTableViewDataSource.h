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
//    EVDashboardPermanentRowSegmentedControl,
    EVDashboardPermanentRowCOUNT
} EVDashboardPermanentRow;

typedef enum {
    EVDashboardSegmentAll,
    EVDashboardSegmentPaying,
    EVDashboardSegmentPaid
} EVDashboardSegment;

@class EVGroupRequest;
@class EVGroupRequestRecord;
@class EVGroupRequestProgressView;
@class EVSegmentedControl;
@class EVBlueButton;

@interface EVGroupRequestDashboardTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) EVGroupRequest *groupRequest;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) EVGroupRequestProgressView *progressView;
@property (nonatomic, strong) EVSegmentedControl *segmentedControl;

@property (nonatomic, strong) EVBlueButton *inviteButton;
@property (nonatomic, strong) EVBlueButton *remindAllButton;

@property (nonatomic, strong) NSArray *displayedRecords;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (EVGroupRequestRecord *)recordAtIndexPath:(NSIndexPath *)indexPath;

- (void)animate;

- (BOOL)noOneHasJoined;

@end
