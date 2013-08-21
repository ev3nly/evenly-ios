//
//  EVContactInviteCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteCell.h"

@interface EVInviteContactCell : EVInviteCell

@property (nonatomic, strong) UILabel *emailLabel;

- (void)setName:(NSString *)name profilePicture:(UIImage *)picture;

@end
