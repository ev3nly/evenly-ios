//
//  EVGroupRequestTierAssignmentManager.h
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVGroupRequestTierAssignmentView.h"
#import "EVGroupRequest.h"

@interface EVGroupRequestTierAssignmentManager : NSObject <EVGroupRequestTierAssignmentDataSource, EVGroupRequestTierAssignmentDelegate>

@property (nonatomic, weak) EVGroupRequest *groupRequest;
@property (nonatomic, strong) NSMutableArray *tierMemberships;
@property (nonatomic) NSInteger representedTierIndex;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

@end
