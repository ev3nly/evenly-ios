//
//  EVMenuViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

typedef enum {
    EVMenuSectionHome = 0,
    EVMenuSectionProfile,
    EVMenuSectionSettings,
    EVMenuSectionSupport,
    EVMenuSectionInvite,
    EVMenuSectionCOUNT
} EVMenuSection;

@interface EVMenuViewController : EVViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
