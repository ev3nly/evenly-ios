//
//  EVAutocompletePhotoCell.h
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVAutocompleteCell.h"
#import "EVAvatarView.h"

@interface EVAutocompletePhotoCell : EVAutocompleteCell

@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *label;

@end
