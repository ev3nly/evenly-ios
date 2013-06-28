//
//  EVGroupRequestDashboardViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestEditViewController.h"

@interface EVGroupRequestDashboardViewController : EVModalViewController <UITableViewDelegate,
                                                                          UIActionSheetDelegate,
                                                                          UIAlertViewDelegate,
                                                                          EVGroupRequestEditViewControllerDelegate>

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

- (void)closeRequest;

@end
