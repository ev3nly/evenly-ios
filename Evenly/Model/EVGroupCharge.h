//
//  EVGroupCharge.h
//  Evenly
//
//  Created by Joseph Hankin on 4/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCharge.h"

@interface EVGroupCharge : EVObject

@property (nonatomic, strong) EVObject<EVExchangeable> *from;
@property (nonatomic, strong) NSArray *tiers;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *memo;

@end
