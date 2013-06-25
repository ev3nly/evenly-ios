//
//  EVEditProfileViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditProfileViewController.h"
#import "EVKeyboardTracker.h"
#import "EVStatusBarManager.h"

#define BUTTON_BUFFER 10

@interface EVEditProfileViewController ()

@property (nonatomic, assign) BOOL keyboardIsHiding;

@end

@implementation EVEditProfileViewController

#pragma mark - Lifecycle

- (id)initWithUser:(EVUser *)user
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = @"Edit Profile";
        self.user = user;
        [self notificationRegistration];
        self.canDismissManually = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    [self loadFooterView];
    [self loadPinButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
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

- (void)loadFooterView {
    self.footerView = [UIView new];
    self.footerView.backgroundColor = [UIColor clearColor];
    self.footerView.frame = [self footerViewFrame];
    self.tableView.tableFooterView = self.footerView;
}

- (void)loadPinButton {
    self.saveButton = [UIButton new];
    [self.saveButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [EVFont defaultButtonFont];
    self.saveButton.frame = [self pinButtonFrame];
    [self.footerView addSubview:self.saveButton];
}

- (void)notificationRegistration {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    else
        cell = [self editLabelCellForIndexPath:indexPath];

    cell.position = [self cellPositionForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView Utility

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
    EVEditLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"editLabelCell" forIndexPath:indexPath];
    
    if (indexPath.row == EVEditProfileCellRowName) {
        [cell setTitle:@"Name" placeholder:self.user.name];
        cell.handleTextChange = ^(NSString *text) {
            if (!EV_IS_EMPTY_STRING(text))
                [EVCIA me].name = text;
        };
    } else if (indexPath.row == EVEditProfileCellRowEmail) {
        [cell setTitle:@"Email" placeholder:self.user.email];
        cell.handleTextChange = ^(NSString *text) {
            if (!EV_IS_EMPTY_STRING(text))
                [EVCIA me].email = text;
        };
    } else if (indexPath.row == EVEditProfileCellRowPhoneNumber) {
        [cell setTitle:@"Phone Number" placeholder:self.user.phoneNumber];
        cell.handleTextChange = ^(NSString *text) {
            if (!EV_IS_EMPTY_STRING(text))
                [EVCIA me].phoneNumber = text;
        };
    }
    return cell;
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

- (void)saveButtonTapped {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress];

    [[EVCIA me] updateWithSuccess:^{
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].completion = ^(void){ [self.navigationController popViewControllerAnimated:YES]; };
    } failure:^(NSError *error) {
        DLog(@"failed to save user: %@", error);
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
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
    [EVCIA me].updatedAvatar = pickedImage;
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

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self displayImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    else if (buttonIndex == 1)
        [self displayImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - Keyboard Display

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardIsHiding = NO;
    [self.view setNeedsLayout];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    UIView *firstResponder = [self.view currentFirstResponder];
    UIView *cell = firstResponder.superview;
    if (!cell || ![cell isKindOfClass:[UITableViewCell class]])
        return;
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)cell];
    self.tableView.frame = [self tableViewFrame];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.tableView.frame = [self tableViewFrame];
                     }];
    self.keyboardIsHiding = YES;
    [self.view setNeedsLayout];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect keyboardFrame = [EVKeyboardTracker sharedTracker].keyboardFrame;
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    if (!self.keyboardIsHiding)
        tableFrame.size.height -= keyboardFrame.size.height;
    return tableFrame;
}

- (CGRect)footerViewFrame {
    return CGRectMake(0,
                      0,
                      self.view.bounds.size.width,
                      BUTTON_BUFFER + [EVImages blueButtonBackground].size.height + BUTTON_BUFFER);
}

- (CGRect)pinButtonFrame {
    return CGRectMake(BUTTON_BUFFER,
                      0,
                      self.view.bounds.size.width - BUTTON_BUFFER*2,
                      [EVImages blueButtonBackground].size.height);
}

@end
