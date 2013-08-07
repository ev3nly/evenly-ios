//
//  EVSignUpViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSignUpViewController.h"
#import "EVWebViewController.h"
#import "EVCheckmarkLinkButton.h"
#import "EVPhotoNameEmailCell.h"
#import "EVFacebookManager.h"
#import "ReactiveCocoa.h"
#import <QuartzCore/QuartzCore.h>
#import "OpenInChromeController.h"

#define CHECK_VIEW_HEIGHT 40
#define FOOTER_VIEW_BOTTOM_MARGIN 10
#define CHECKMARK_BUFFER 14
#define BUTTON_BUFFER 10

@interface EVSignUpViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVCheckmarkLinkButton *syncContactsButton;
@property (nonatomic, strong) EVCheckmarkLinkButton *tosAgreementButton;

@property (nonatomic, strong) UIImage *photo;

@property (nonatomic, strong) EVPhotoNameEmailCell *photoNameEmailCell;
@property (nonatomic, strong) EVEditLabelCell *phoneNumberCell;
@property (nonatomic, strong) EVEditLabelCell *passwordCell;

@property (nonatomic, strong) EVUser *user;

@end

@implementation EVSignUpViewController

#pragma mark - Lifecycle

- (id)initWithSignUpSuccess:(void (^)(void))success
{
    if (self = [super initWithUser:[EVUser new]]) {
        self.canDismissManually = YES;
        self.title = @"Sign Up";
        self.authenticationSuccess = success;
    }
    return self;
}

- (id)initWithSignUpSuccess:(void (^)(void))success user:(EVUser *)user {
    if (self = [self initWithSignUpSuccess:success]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCells];
    [self configureReactions];
    self.saveButton.enabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)];
    tapRecognizer.delegate = self;
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.user.name)
        [self.photoNameEmailCell.nameField becomeFirstResponder];
    else if (!self.user.email)
        [self.photoNameEmailCell.emailField becomeFirstResponder];
    else
        [self.phoneNumberCell.textField becomeFirstResponder];
}

#pragma mark - Setup

- (void)loadFooterView {
    [super loadFooterView];
    
    [self loadSyncContactsButton];
    [self loadTosAgreementButton];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[EVPhotoNameEmailCell class] forCellReuseIdentifier:@"photoNameEmailCell"];
}

- (void)loadChangePasswordButton {
}

- (void)loadPinButton {
    [super loadPinButton];
    
    [self.saveButton setTitle:@"COMPLETE & SET PIN" forState:UIControlStateNormal];
    self.saveButton.enabled = NO;
    CGRect saveFrame = self.saveButton.frame;
    saveFrame.origin.y = self.footerView.bounds.size.height - saveFrame.size.height - FOOTER_VIEW_BOTTOM_MARGIN;
    self.saveButton.frame = saveFrame;
}

- (void)loadSyncContactsButton {
    self.syncContactsButton = [[EVCheckmarkLinkButton alloc] initWithText:@"Sync Contacts to Server"];
    self.syncContactsButton.checked = YES;
    self.syncContactsButton.frame = [self syncContactsButtonFrame];
    [self.footerView addSubview:self.syncContactsButton];
}

- (void)loadTosAgreementButton {
    self.tosAgreementButton = [[EVCheckmarkLinkButton alloc] initWithText:@"I agree to the terms of service and privacy policy"];
    self.tosAgreementButton.frame = [self tosAgreementButtonFrame];
    [self.tosAgreementButton setLinkDelegate:self];
    [self.tosAgreementButton linkToUrl:[self tosUrl] forText:@"terms of service"];
    [self.tosAgreementButton linkToUrl:[self privacyPolicyUrl] forText:@"privacy policy"];
    [self.footerView addSubview:self.tosAgreementButton];
}

- (void)loadCells {
    self.photoNameEmailCell = [self cellForPhotoNameEmail];
    self.phoneNumberCell = [self createdCellForRow:EVSignUpCellRowPhoneNumber];
    self.passwordCell = [self createdCellForRow:EVSignUpCellRowPassword];
}

- (void)configureReactions {
    [RACAble(self.user.avatar) subscribeNext:^(UIImage *image) {
        self.photo = image;
        self.photoNameEmailCell.photo = self.photo;
    }];
        
    [self.phoneNumberCell.textField.rac_textSignal subscribeNext:^(NSString *text) {
        text = [EVStringUtility addHyphensToPhoneNumber:text];
        self.phoneNumberCell.textField.text = text;
        if (text.length == 12)
            [self.passwordCell.textField becomeFirstResponder];
    }];
}

#pragma mark - TOS/Privacy Policy

- (NSURL *)tosUrl {
    return [NSURL fileURLWithPath:EV_BUNDLE_PATH(@"Terms and Conditions.html")];
}

- (NSURL *)privacyPolicyUrl {
    return [NSURL fileURLWithPath:EV_BUNDLE_PATH(@"Privacy Policy.html")];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {    
    EVWebViewController *controller = [[EVWebViewController alloc] initWithURL:url];
    controller.title = [url isEqual:[self tosUrl]] ? @"Terms of Service" : @"Privacy Policy";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}
 
#pragma mark - Gesture Handling

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[EVCheckmarkLinkButton class]])
        return YES;
    return NO;
}

- (void)saveButtonTapped {
    if (![self formFinished]) {
        [self informUserFormNotFinished];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"name" : self.photoNameEmailCell.nameField.text,
                                   @"email" : self.photoNameEmailCell.emailField.text,
                                   @"phone_number" : self.phoneNumberCell.textField.text,
                                   @"password" : self.passwordCell.textField.text,
                                   @"password_confirmation" : self.passwordCell.textField.text,
                                   @"facebook_id" : [EVFacebookManager sharedManager].facebookID,
                                   @"facebook_token" : [EVFacebookManager sharedManager].tokenData.accessToken }];
    if (self.photo)
        [params setObject:self.photo forKey:@"avatar"];
    
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CREATING ACCOUNT..."];
    
    [EVUser createWithParams:params success:^(EVObject *object) {
        [EVSession createWithEmail:params[@"email"] password:params[@"password"] success:^{
            
            EVUser *me = [[EVUser alloc] initWithDictionary:[EVSession sharedSession].originalDictionary[@"user"]];
            me.password = params[@"password"];
            me.updatedAvatar = self.photo;
            [[EVCIA sharedInstance] setMe:me];
            
            [EVUtilities registerForPushNotifications];
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                if (self.authenticationSuccess)
                    self.authenticationSuccess();
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"Error logging in: %@", error);
        }];
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        DLog(@"Error creating user: %@", error);
    }];
}

- (void)informUserFormNotFinished {
    [[UIAlertView alertViewWithTitle:@"Whoops!" message:[self formNotFinishedMessage] cancelButtonTitle:@"OK"] show];
}

- (BOOL)formFinished {
    if (EV_IS_EMPTY_STRING(self.photoNameEmailCell.nameField.text))
        return NO;
    else if (EV_IS_EMPTY_STRING(self.photoNameEmailCell.emailField.text))
        return NO;
    else if (EV_IS_EMPTY_STRING(self.phoneNumberCell.textField.text))
        return NO;
    else if (EV_IS_EMPTY_STRING(self.passwordCell.textField.text) || self.passwordCell.textField.text.length < 8)
        return NO;
    else if (!self.tosAgreementButton.checked)
        return NO;
    return YES;
}

- (NSString *)formNotFinishedMessage {
    if (EV_IS_EMPTY_STRING(self.photoNameEmailCell.nameField.text))
        return @"You must enter your name.";
    else if (EV_IS_EMPTY_STRING(self.photoNameEmailCell.emailField.text))
        return @"You must enter your email";
    else if (EV_IS_EMPTY_STRING(self.phoneNumberCell.textField.text))
        return @"You must enter your phone number";
    else if (EV_IS_EMPTY_STRING(self.passwordCell.textField.text))
        return @"You must enter your password";
    else if (self.passwordCell.textField.text.length < 8)
        return @"Your password must be at least 8 characters";
    else if (!self.tosAgreementButton.checked)
        return @"You must accept the Terms of Service";
    return @"";
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    pickedImage = [EVImageUtility orientedImageFromImage:pickedImage];
    self.photo = [EVImageUtility resizeImage:pickedImage toSize:[EVImageUtility sizeForImage:pickedImage withInnerBoundingSize:EV_USER_TAKEN_AVATAR_BOUNDING_SIZE]];
    self.photoNameEmailCell.photo = pickedImage;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVSignUpCellRowCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVSignUpCellRowPhotoNameEmail)
        return [EVPhotoNameEmailCell cellHeight];
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    
    if (indexPath.row == EVSignUpCellRowPhotoNameEmail)
        cell = self.photoNameEmailCell;
    else
        cell = [self editLabelCellForIndexPath:indexPath];
    
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Cell Creation

- (EVPhotoNameEmailCell *)cellForPhotoNameEmail {
    EVPhotoNameEmailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"photoNameEmailCell"];
    cell.photo = self.photo ? self.photo : [EVImages addPhotoIcon];

    if (self.user.avatar)
        cell.photo = self.user.avatar;
    [cell.profilePictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)]];
    
    if (self.user.name)
        cell.nameField.text = self.user.name;
    if (self.user.email)
        cell.emailField.text = self.user.email;

    cell.handleEnteredEmail = ^{
        [self.phoneNumberCell.textField becomeFirstResponder];
    };
    
    return cell;
}

- (EVEditLabelCell *)editLabelCellForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVSignUpCellRowPhoneNumber)
        return self.phoneNumberCell;
    else if (indexPath.row == EVSignUpCellRowPassword)
        return self.passwordCell;
    return nil;
}

- (EVEditLabelCell *)createdCellForRow:(EVSignUpCellRow)row {
    EVEditLabelCell *editLabelCell = [[EVEditLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editLabelCell"];
    editLabelCell.textField.returnKeyType = UIReturnKeyNext;
    editLabelCell.textField.delegate = self;
    editLabelCell.tag = row;
    
    if (row == EVSignUpCellRowPhoneNumber) {
        [editLabelCell setTitle:@"Phone Number" placeholder:@"XXX-XXX-XXXX"];
        editLabelCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneNumberCell = editLabelCell;
    } else if (row == EVSignUpCellRowPassword) {
        [editLabelCell setTitle:@"Password" placeholder:@"at least 8 characters"];
        editLabelCell.textField.secureTextEntry = YES;
        editLabelCell.textField.returnKeyType = UIReturnKeyDone;
        self.passwordCell = editLabelCell;
    }
    return editLabelCell;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    int nextCellRow = (textField.superview.tag + 1);
    if (nextCellRow == EVSignUpCellRowCOUNT) {
        [textField resignFirstResponder];
        return YES;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextCellRow inSection:0];
    EVEditLabelCell *cell = (EVEditLabelCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    return YES;
}

#pragma mark - Keyboard Handling

- (void)keyboardDidShow:(NSNotification *)notification {
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = [super tableViewFrame];
    tableFrame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
    return tableFrame;
}

- (CGRect)footerViewFrame {
    CGRect footerFrame = [super footerViewFrame];
    footerFrame.size.height = BUTTON_BUFFER + [EVImages blueButtonBackground].size.height + BUTTON_BUFFER + CHECK_VIEW_HEIGHT*2 + CHECKMARK_BUFFER*2;
    return footerFrame;
}

- (CGRect)syncContactsButtonFrame {
    return CGRectMake(0,
                      0,
                      self.footerView.bounds.size.width,
                      CHECK_VIEW_HEIGHT);
}

- (CGRect)tosAgreementButtonFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.syncContactsButton.frame) + CHECKMARK_BUFFER,
                      self.footerView.bounds.size.width,
                      CHECK_VIEW_HEIGHT);
}

- (CGRect)pinButtonFrame {
    return CGRectMake(BUTTON_BUFFER,
                      0,
                      self.view.bounds.size.width - BUTTON_BUFFER*2,
                      [EVImages blueButtonBackground].size.height);
}

@end
