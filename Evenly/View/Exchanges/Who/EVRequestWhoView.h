//
//  EVRequestInitialView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVExchangeWhoView.h"
#import "EVRequestSwitch.h"

@interface EVRequestWhoView : EVExchangeWhoView <EVSwitchDelegate>

@property (nonatomic, strong) EVRequestSwitch *requestSwitch;
@property (nonatomic) BOOL didForceSwitchToGroup;

@end
