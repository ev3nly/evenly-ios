//
//  EVHistoryItem.h
//  Evenly
//
//  Created by Joseph Hankin on 8/22/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVHistoryItem : EVObject

@property (nonatomic, strong) id source;
@property (nonatomic, strong) EVObject<EVExchangeable> *from;
@property (nonatomic, strong) EVObject<EVExchangeable> *to;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) NSArray *details;
@property (nonatomic, strong) NSString *title;

@end
