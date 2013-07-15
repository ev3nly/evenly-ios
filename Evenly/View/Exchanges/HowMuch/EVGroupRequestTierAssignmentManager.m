//
//  EVGroupRequestTierAssignmentManager.m
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTierAssignmentManager.h"

@interface EVGroupRequestTierAssignmentManager ()

@property (nonatomic, strong) NSArray *alphabetizedMembers;

@end

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
    self.alphabetizedMembers = nil;
}

#pragma mark - EVGroupRequestTierAssignmentViewDataSource

- (NSArray *)fullMembershipForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view {
    if (!self.alphabetizedMembers)
    {
        self.alphabetizedMembers = [self.groupRequest.members sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] compare:[obj2 name]];
        }];
    }
    return self.alphabetizedMembers;
}

- (NSArray *)assignmentsForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view {
    return self.tierMemberships;
}

- (NSInteger)tierIndexForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view {
    return self.representedTierIndex;
}

#pragma mark - EVGroupRequesttierAssignmentViewDelegate

- (void)tierAssignmentView:(EVGroupRequestTierAssignmentView *)view didSelectMemberAtIndex:(NSInteger)index {
    NSMutableArray *memberships = [self.tierMemberships objectAtIndex:self.representedTierIndex];
    EVObject<EVExchangeable> *member = [[self fullMembershipForTierAssignmentView:view] objectAtIndex:index];
    if ([memberships containsObject:member]) {
        [memberships removeObject:member];
    } else {
        for (NSMutableArray *otherMemberships in self.tierMemberships) {
            [otherMemberships removeObject:member];
        }
        [memberships addObject:member];
    }
    [self.delegate tierAssignmentManagerDidUpdateMemberships:self];
}

@end
