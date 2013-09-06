//
//  EVEditProfileViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditProfileViewController.h"
#import "EVChangePasswordViewController.h"
#import "EVKeyboardTracker.h"
#import "EVStatusBarManager.h"
#import "ReactiveCocoa.h"

#define BUTTON_BUFFER 10

@interface EVEditProfileViewController ()

@property (nonatomic, assign) BOOL keyboardIsHiding;
@property (nonatomic, strong) UIButton *changePasswordButton;

@end

@implementation EVEditProfileViewController

#pragma mark - Lifecycle

- (id)initWithUser:(EVUser *)user
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = @"Edit Profile";
        self.user = [EVCIA me];
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
    [self loadChangePasswordButton];
    [self loadPinButton];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)];
    tapRecognizer.delegate = self;
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
    self.changePasswordButton.frame = [self changePasswordButtonFrame];
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

- (void)loadChangePasswordButton {
    self.changePasswordButton = [UIButton new];
    [self.changePasswordButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
    [self.changePasswordButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.changePasswordButton addTarget:self action:@selector(changePasswordButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.changePasswordButton setTitle:@"Change Password" forState:UIControlStateNormal];
    [self.changePasswordButton setTitleColor:[EVColor darkColor] forState:UIControlStateNormal];
    self.changePasswordButton.titleLabel.font = [EVFont defaultButtonFont];
    self.changePasswordButton.frame = [self changePasswordButtonFrame];
    [self.footerView addSubview:self.changePasswordButton];
}

- (void)loadPinButton {
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

    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView Utility

- (EVGroupedTableViewCell *)editPhotoCell {
    EVEditPhotoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"editPhotoCell"];
    if (self.updatedImage)
        cell.avatarView.image = self.updatedImage;
    else if ([EVCIA me].updatedAvatar)
        cell.avatarView.image = [EVCIA me].updatedAvatar;
    else
        cell.avatarView.avatarOwner = [EVCIA me];

    if ([cell.gestureRecognizers count] == 0)
        [cell.avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)]];
    return cell;
}

- (EVEditLabelCell *)editLabelCellForIndexPath:(NSIndexPath *)indexPath {
    EVEditLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"editLabelCell" forIndexPath:indexPath];
    
    if (indexPath.row == EVEditProfileCellRowName) {
        [cell setTitle:@"Name" placeholder:[EVCIA me].name];
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.handleTextChange = ^(NSString *text) {
            if (!EV_IS_EMPTY_STRING(text))
                [EVCIA me].name = text;
        };
    } else if (indexPath.row == EVEditProfileCellRowEmail) {
        [cell setTitle:@"Email" placeholder:[EVCIA me].email];
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.handleTextChange = ^(NSString *text) {
            if (!EV_IS_EMPTY_STRING(text))
                [EVCIA me].email = text;
        };
    } else if (indexPath.row == EVEditProfileCellRowPhoneNumber) {
        [cell setTitle:@"Phone Number" placeholder:[EVStringUtility addHyphensToPhoneNumber:[EVCIA me].phoneNumber]];
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.handleTextChange = ^(NSString *text) {
            if (!EV_IS_EMPTY_STRING(text))
                [EVCIA me].phoneNumber = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        };
        [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
            text = [EVStringUtility addHyphensToPhoneNumber:text];
            cell.textField.text = text;
            if (text.length == 12)
                [cell.textField resignFirstResponder];
        }];
    }
    return cell;
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

- (void)changePasswordButtonTapped {
    EVChangePasswordViewController *changePasswordController = [[EVChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:changePasswordController animated:YES];
}

- (void)backButtonPress:(id)sender {
    [self.view findAndResignFirstResponder];
    [[EVCIA me] updateWithSuccess:^{
        if (self.handleSave)
            self.handleSave([EVCIA me]);
    } failure:^(NSError *error) {
        DLog(@"failed to save user: %@", error);
    }];
    
    [super backButtonPress:sender];
}

#pragma mark - Image Picker

- (void)displayImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
//    imagePicker.view.backgroundColor = [UIColor blackColor];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    pickedImage = [EVImageUtility orientedImageFromImage:pickedImage];
    self.updatedImage = [EVImageUtility resizeImage:pickedImage toSize:[EVImageUtility sizeForImage:pickedImage withInnerBoundingSize:EV_USER_TAKEN_AVATAR_BOUNDING_SIZE]];
    [EVCIA me].updatedAvatar = pickedImage;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
                      BUTTON_BUFFER + [EVImages blueButtonBackground].size.height*2 + BUTTON_BUFFER*2);
}

- (CGRect)changePasswordButtonFrame {
    return CGRectMake(BUTTON_BUFFER,
                      BUTTON_BUFFER/2,
                      self.view.bounds.size.width - BUTTON_BUFFER*2,
                      [EVImages blueButtonBackground].size.height);
}

@end
