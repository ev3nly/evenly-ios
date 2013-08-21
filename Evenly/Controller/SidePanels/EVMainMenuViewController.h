//
//  EVMenuViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSidePanelViewController.h"
#import <MessageUI/MessageUI.h>

typedef enum {
    EVMainMenuOptionHome = 0,
    EVMainMenuOptionProfile,
    EVMainMenuOptionSettings,
    EVMainMenuOptionSupport,
    EVMainMenuOptionInvite,
    EVMainMenuOptionCOUNT
} EVMainMenuOption;

typedef enum {
    EVSupportOptionFAQ = 0,
    EVSupportOptionEmail,
    EVSupportOptionTwitter
} EVSupportOption;

@interface EVMainMenuViewController : EVSidePanelViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
