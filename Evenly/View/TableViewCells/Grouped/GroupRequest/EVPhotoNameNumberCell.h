//
//  EVPhotoNameNumberCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVPhotoNameNumberCell : EVGroupedTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *profilePictureView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UIImage *photo;

+ (float)cellHeight;

@end
