//
//  EVGroupRequestTierAssignmentManager.m
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTierAssignmentManager.h"

@implementation EVGroupRequestTierAssignmentManager

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [self init];
    if (self) {
        self.groupRequest = groupRequest;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tierMemberships = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
    }
    return self;
}

- (void)setGroupRequest:(EVGroupRequest *)groupRequest {
    _groupRequest = groupRequest;
}

#pragma mark - EVGroupRequestTierAssignmentViewDataSource

- (NSArray *)fullMembershipForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view {
    return [self.groupRequest.members sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] compare:[obj2 name]];
    }];
}

- (NSArray *)assignmentsForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view {
    return self.tierMemberships;
}

- (NSInteger)tierIndexForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view {
    return self.representedTierIndex;
}

#pragma mark - EVGroupRequesttierAssignmentViewDelegate

- (void)tierAssignmentView:(EVGroupRequestTierAssignmentView *)view didSelectMember:(EVObject<EVExchangeable> *)member {
    NSMutableArray *memberships = [self.tierMemberships objectAtIndex:self.representedTierIndex];
    if ([memberships containsObject:member]) {
        [memberships removeObject:member];
    } else {
        [memberships addObject:member];
    }
}

@end
