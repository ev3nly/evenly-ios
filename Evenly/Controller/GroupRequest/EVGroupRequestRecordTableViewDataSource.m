//
//  EVGropuRequestRecordTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecordTableViewDataSource.h"
#import "EVGroupRequestUserCell.h"

#define USER_ROW_HEIGHT 64.0

@implementation EVGroupRequestRecordTableViewDataSource

- (id)initWithRecord:(EVGroupRequestRecord *)record {
    self = [super init];
    if (self) {
        self.record = record;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Unpaid, unassigned
    if (self.record.tier == nil)
        return 3;
    
    // Fully paid
    if (self.record.completed)
        return 3;
    
    // Unpaid, assigned / partially paid
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    if (indexPath.row == 0) {
        EVGroupRequestUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        userCell.nameLabel.text = self.record.user.name;
        userCell.avatarView.avatarOwner = self.record.user;
        cell = userCell;
    }
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return USER_ROW_HEIGHT;
    return 44.0;
}

@end
