//
//  EVInviteViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

typedef enum {
    EVInviteMethodFacebook,
    EVInviteMethodContacts,
    EVInviteMethodCOUNT
} EVInviteMethod;

@interface EVInviteViewController : EVViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end
