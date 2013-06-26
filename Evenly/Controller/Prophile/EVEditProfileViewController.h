//
//  EVEditProfileViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVEditPhotoCell.h"
#import "EVEditLabelCell.h"

typedef enum {
    EVEditProfileCellRowPhoto,
    EVEditProfileCellRowName,
    EVEditProfileCellRowEmail,
    EVEditProfileCellRowPhoneNumber,
    EVEditProfileCellRowCOUNT
} EVEditProfileCellRow;

@interface EVEditProfileViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVUser *user;

@property (nonatomic, strong) UIImage *updatedImage;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *saveButton;

- (id)initWithUser:(EVUser *)user;

- (void)loadFooterView;
- (void)loadPinButton;

- (void)saveButtonTapped;

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath;
- (EVGroupedTableViewCell *)editPhotoCell;
- (EVEditLabelCell *)editLabelCellForIndexPath:(NSIndexPath *)indexPath;

- (CGRect)tableViewFrame;
- (CGRect)footerViewFrame;

@end
