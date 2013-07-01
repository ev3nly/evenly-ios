//
//  EVConnection.h
//  Evenly
//
//  Created by Joseph Hankin on 6/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVUser;

@interface EVConnection : EVObject

@property (nonatomic, strong) EVUser *user;
@property (nonatomic) int strength;

@end
