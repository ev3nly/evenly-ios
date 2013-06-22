//
//  EVProfileCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVUser.h"

@class EVProfileViewController;

@interface EVProfileCell : EVGroupedTableViewCell

@property (nonatomic, weak) EVProfileViewController *parent;
@property (nonatomic, strong) EVUser *user;
@property (nonatomic, strong) UIButton *profileButton;

+ (float)cellHeightForUser:(EVUser *)user;

@end
