//
//  EVPhotoNameEmailCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVAvatarView.h"

@interface EVPhotoNameEmailCell : EVGroupedTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) EVAvatarView *profilePictureView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) void (^handleEnteredEmail)(void);

+ (float)cellHeight;

@end
