//
//  EVGroupRequestInviteViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/15/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteContactsViewController.h"

@class EVGroupRequest;
@class EVGroupRequestInviteViewController;

@protocol EVGroupRequestInviteViewControllerDelegate <NSObject>

- (void)inviteViewController:(EVGroupRequestInviteViewController *)controller sentInvitesTo:(NSArray *)invitees;

@end

@interface EVGroupRequestInviteViewController : EVInviteContactsViewController

@property (nonatomic, strong) EVGroupRequest *groupRequest;
@property (nonatomic, weak) id<EVGroupRequestInviteViewControllerDelegate> delegate;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

@end
