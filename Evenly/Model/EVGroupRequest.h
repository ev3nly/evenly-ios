//
//  EVGroupRequest.h
//  Evenly
//
//  Created by Joseph Hankin on 4/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVGroupRequestTier;

@interface EVGroupRequest : EVObject

@property (nonatomic, strong) EVObject<EVExchangeable> *from;
@property (nonatomic, strong) NSArray *tiers;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic) BOOL completed;

@property (nonatomic, readonly) UIImage *avatar;

- (EVGroupRequestTier *)tierWithID:(NSString *)tierID;

@end
