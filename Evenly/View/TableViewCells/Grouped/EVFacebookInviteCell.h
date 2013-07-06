//
//  EVFacebookInviteCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVFacebookInviteCell : EVGroupedTableViewCell

@property (nonatomic, assign) BOOL shouldInvite;
@property (nonatomic, strong) void (^handleSelection)(NSString *profileID);
@property (nonatomic, strong) void (^handleDeselection)(NSString *profileID);

+ (float)cellHeight;
- (void)setName:(NSString *)name profileID:(NSString *)profileID;

@end
