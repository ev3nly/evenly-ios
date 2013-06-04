//
//  EVMenuViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import <MessageUI/MessageUI.h>

typedef enum {
    EVMainMenuOptionHome = 0,
    EVMainMenuOptionProfile,
    EVMainMenuOptionSettings,
    EVMainMenuOptionSupport,
    EVMainMenuOptionInvite,
    EVMainMenuOptionCOUNT
} EVMainMenuOption;

@interface EVMainMenuViewController : EVViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
