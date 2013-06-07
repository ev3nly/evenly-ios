//
//  EVStory.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStory.h"
#import "EVUser.h"
#import "EVPayment.h"
#import "EVCharge.h"

@implementation EVStory

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    // Easy things first
    self.verb = properties[@"verb"];
    self.isPrivate = [properties[@"private"] boolValue];
    self.storyDescription = properties[@"description"];
    if ([properties[@"amount"] isKindOfClass:[NSDecimalNumber class]])
        self.amount = properties[@"amount"];
    else
        self.amount = [NSDecimalNumber decimalNumberWithString:properties[@"amount"]];
    
    // Subject
    NSString *subjectClass = [NSString stringWithFormat:@"EV%@", properties[@"subject_type"]];
    self.subject = [[NSClassFromString(subjectClass) alloc] init];
    [self.subject setName:properties[@"subject_name"]];
    [self.subject setDbid:properties[@"subject_id"]];
    
    // Target
    if (properties[@"target_type"] != [NSNull null])
    {
        NSString *targetClass = [NSString stringWithFormat:@"EV%@", properties[@"target_type"]];
        self.target = [[NSClassFromString(targetClass) alloc] init];
        [self.target setName:properties[@"target_name"]];
        [self.target setDbid:properties[@"target_id"]];
    }
    
    // Owner
    NSString *ownerClass = [NSString stringWithFormat:@"EV%@", properties[@"owner_type"]];
    self.owner = [[NSClassFromString(ownerClass) alloc] init];
    [self.owner setDbid:properties[@"owner_id"]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<EVStory: 0x%x> %@ %@ %@ for %@", (int)self, [self.subject name], self.verb, [self.target name], self.storyDescription];
}

@end
