//
//  EVGropuRequestRecordTableViewDataSource.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVGroupRequestRecord.h"

@interface EVGropuRequestRecordTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) EVGroupRequestRecord *record;

- (id)initWithGroupRequestRecord:(EVGroupRequestRecord *)record;

@end
