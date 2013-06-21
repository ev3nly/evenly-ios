//
//  EVGroupRequestDashboardTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestDashboardTableViewDataSource.h"
#import "EVGroupCharge.h"
#import "EVDashboardTitleCell.h"

@implementation EVGroupRequestDashboardTableViewDataSource

- (id)initWithGroupCharge:(EVGroupCharge *)groupCharge {
    self = [super init];
    if (self) {
        self.groupCharge = groupCharge;
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.groupCharge.records count] == 0) {
        return EVDashboardPermanentRowCOUNT + 1;
    }
    return EVDashboardPermanentRowCOUNT + [self.groupCharge.records count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVDashboardPermanentRowTitle)
    {
        return [EVDashboardTitleCell heightWithTitle:self.groupCharge.title memo:self.groupCharge.memo];
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVDashboardPermanentRowTitle)
    {
        EVDashboardTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        [titleCell.titleLabel setText:self.groupCharge.title];
        [titleCell.memoLabel setText:self.groupCharge.memo];
        return titleCell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
}



@end
