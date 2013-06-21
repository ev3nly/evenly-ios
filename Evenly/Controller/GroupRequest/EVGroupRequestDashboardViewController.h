//
//  EVGroupRequestDashboardViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVGroupCharge.h"

@interface EVGroupRequestDashboardViewController : EVModalViewController <UITableViewDelegate>

- (id)initWithGroupCharge:(EVGroupCharge *)groupCharge;

@end
