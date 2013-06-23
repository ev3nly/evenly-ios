//
//  EVEditProfileViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

typedef enum {
    EVEditProfileCellRowPhoto,
    EVEditProfileCellRowName,
    EVEditProfileCellRowEmail,
    EVEditProfileCellRowPhoneNumber,
    EVEditProfileCellRowPassword,
    EVEditProfileCellRowCOUNT
} EVEditProfileCellRow;

@interface EVEditProfileViewController : EVViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVUser *user;

- (id)initWithUser:(EVUser *)user;

@end
