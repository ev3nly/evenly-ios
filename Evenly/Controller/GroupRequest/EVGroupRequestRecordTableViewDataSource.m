//
//  EVGropuRequestRecordTableViewDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecordTableViewDataSource.h"

@implementation EVGroupRequestRecordTableViewDataSource

- (id)initWithGroupRequestRecord:(EVGroupRequestRecord *)record {
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
    
}

@end
