//
//  EVEditProfileViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditProfileViewController.h"
#import "EVEditPhotoCell.h"
#import "EVEditLabelCell.h"

@interface EVEditProfileViewController ()

@property (nonatomic, strong) UIImage *updatedImage;

@end

@implementation EVEditProfileViewController

- (id)initWithUser:(EVUser *)user
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = @"Edit Profile";
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVEditPhotoCell class] forCellReuseIdentifier:@"editPhotoCell"];
    [self.tableView registerClass:[EVEditLabelCell class] forCellReuseIdentifier:@"editLabelCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVEditProfileCellRowCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVEditProfileCellRowPhoto)
        return [EVEditPhotoCell cellHeight];
    return [EVEditLabelCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    
    if (indexPath.row == EVEditProfileCellRowPhoto)
        cell = [self editPhotoCell];
    else {
        EVEditLabelCell *editLabelCell = [self editLabelCellForIndexPath:indexPath];
        if (indexPath.row == EVEditProfileCellRowName) {
            [editLabelCell setTitle:@"Name" placeholder:self.user.name];
        } else if (indexPath.row == EVEditProfileCellRowEmail) {
            [editLabelCell setTitle:@"Email" placeholder:self.user.email];
        } else if (indexPath.row == EVEditProfileCellRowPhoneNumber) {
            [editLabelCell setTitle:@"Phone Number" placeholder:self.user.phoneNumber];
        } else if (indexPath.row == EVEditProfileCellRowPassword) {
            [editLabelCell setTitle:@"Password" placeholder:self.user.password];
        }
        cell = editLabelCell;
    }
    cell.position = [self cellPositionForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Gesture Handling

- (void)photoTapped {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self displayImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Image Picker

- (void)displayImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.view.backgroundColor = [UIColor blackColor];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.updatedImage = pickedImage;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
        viewController.view.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - Utility

- (EVGroupedTableViewCell *)editPhotoCell {
    EVEditPhotoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"editPhotoCell"];
    cell.avatarView.avatarOwner = self.user;
    if (self.updatedImage)
        cell.avatarView.image = self.updatedImage;
    if ([cell.gestureRecognizers count] == 0)
        [cell.avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)]];
    return cell;
}

- (EVEditLabelCell *)editLabelCellForIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:@"editLabelCell" forIndexPath:indexPath];
}

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (rowCount <= 1)
        return EVGroupedTableViewCellPositionSingle;
    else {
        if (indexPath.row == 0)
            return EVGroupedTableViewCellPositionTop;
        else if (indexPath.row == rowCount - 1)
            return EVGroupedTableViewCellPositionBottom;
        else
            return EVGroupedTableViewCellPositionCenter;
    }
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    return tableFrame;
}

@end
