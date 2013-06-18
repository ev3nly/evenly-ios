//
//  EVRequestSwitch.h
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSwitch.h"
#import "EVRequestSwitchOption.h"

@interface EVRequestSwitch : EVSwitch

@property (nonatomic, strong) EVRequestSwitchOption *friendOption;
@property (nonatomic, strong) EVRequestSwitchOption *groupOption;

@end
