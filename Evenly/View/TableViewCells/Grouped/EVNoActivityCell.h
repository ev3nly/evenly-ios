//
//  EVNoActivityCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVNoActivityCell : EVGroupedTableViewCell

@property (nonatomic, assign) BOOL userIsSelf;

+ (float)cellHeightForUser:(EVUser *)user;

@end
