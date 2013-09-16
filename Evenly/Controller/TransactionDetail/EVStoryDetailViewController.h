//
//  EVStoryDetailViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVTransactionDetailCell.h"

@class EVStory;

typedef enum {
    EVStoryDetailViewControllerSectionStory,
    EVStoryDetailViewControllerSectionLikes,
    EVStoryDetailViewControllerSectionCOUNT
} EVStoryDetailViewControllerSection;

@interface EVStoryDetailViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate, EVTransactionDetailCellDelegate, EVReloadable>

@property (nonatomic, strong) EVStory *story;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithStory:(EVStory *)story;
- (void)avatarTappedForUser:(EVUser *)user;

@end
