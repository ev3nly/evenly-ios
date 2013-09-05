//
//  EVInviteViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

typedef enum {
    EVInviteMethodFacebook,
    EVInviteMethodContacts,
    EVInviteMethodLink,
    EVInviteMethodCOUNT
} EVInviteMethod;

@interface EVInviteViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@end
