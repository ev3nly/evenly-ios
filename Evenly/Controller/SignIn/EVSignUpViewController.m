//
//  EVSignUpViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSignUpViewController.h"
#import "EVCheckmarkButton.h"
#import "ReactiveCocoa.h"

#define CHECK_VIEW_HEIGHT 40
#define FOOTER_VIEW_BOTTOM_MARGIN 10
#define CHECKMARK_BUFFER 14

@interface EVSignUpViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVCheckmarkButton *syncContactsButton;
@property (nonatomic, strong) EVCheckmarkButton *tosAgreementButton;

@property (nonatomic, strong) UIImage *photo;

@property (nonatomic, strong) EVEditLabelCell *nameCell;
@property (nonatomic, strong) EVEditLabelCell *emailCell;
@property (nonatomic, strong) EVEditLabelCell *phoneNumberCell;
@property (nonatomic, strong) EVEditLabelCell *passwordCell;
@property (nonatomic, strong) EVEditLabelCell *passwordConfirmationCell;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadLabelCells];
    [self configureReactions];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
}

#pragma mark - Setup

- (void)loadFooterView {
    [super loadFooterView];
    
    [self loadSyncContactsButton];
    [self loadTosAgreementButton];
    self.tableView.tableFooterView = self.footerView;
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
    self.syncContactsButton = [[EVCheckmarkButton alloc] initWithText:@"Sync Contacts to Server"];
    self.syncContactsButton.checked = YES;
    self.syncContactsButton.frame = [self syncContactsButtonFrame];
    [self.footerView addSubview:self.syncContactsButton];
}

- (void)loadTosAgreementButton {
    self.tosAgreementButton = [[EVCheckmarkButton alloc] initWithText:@"I agree to the terms of service and privacy policy"];
    self.tosAgreementButton.frame = [self tosAgreementButtonFrame];
    [self.footerView addSubview:self.tosAgreementButton];
}

- (void)loadLabelCells {
    self.nameCell = [self createdCellForRow:EVSignUpCellRowName];
    self.emailCell = [self createdCellForRow:EVSignUpCellRowEmail];
    self.phoneNumberCell = [self createdCellForRow:EVSignUpCellRowPhoneNumber];
    self.passwordCell = [self createdCellForRow:EVSignUpCellRowPassword];
    self.passwordConfirmationCell = [self createdCellForRow:EVSignUpCellRowConfirmPassword];
}

- (void)configureReactions {
    
    [self.phoneNumberCell.textField.rac_textSignal subscribeNext:^(NSString *text) {
        text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (text.length > 10)
            text = [text substringToIndex:10];
        if (text.length > 6) {
            NSString *firstThree = [text substringWithRange:NSMakeRange(0, 3)];
            NSString *nextThree = [text substringWithRange:NSMakeRange(3, 3)];
            NSString *rest = [text substringFromIndex:6];
            text = [NSString stringWithFormat:@"%@-%@-%@", firstThree, nextThree, rest];
        } else if (text.length > 3) {
            NSString *firstThree = [text substringWithRange:NSMakeRange(0, 3)];
            NSString *rest = [text substringFromIndex:3];
            text = [NSString stringWithFormat:@"%@-%@", firstThree, rest];
        }
        self.phoneNumberCell.textField.text = text;
    }];
    
    NSArray *textFieldArray = @[self.nameCell.textField.rac_textSignal,
                                self.emailCell.textField.rac_textSignal,
                                self.phoneNumberCell.textField.rac_textSignal,
                                self.passwordCell.textField.rac_textSignal,
                                self.passwordConfirmationCell.textField.rac_textSignal,
                                RACAble(self.tosAgreementButton.checked)];
    
    RACSignal *validFormSignal = [RACSignal combineLatest:textFieldArray
                                                   reduce:^(NSString *name, NSString *email, NSString *phoneNumber, NSString *password, NSString *passwordConfirmation, NSNumber *agreementBool) {
                                                       BOOL isValid = YES;
                                                       if (EV_IS_EMPTY_STRING(name))
                                                           isValid = NO;
                                                       else if (EV_IS_EMPTY_STRING(email))
                                                           isValid = NO;
                                                       else if (EV_IS_EMPTY_STRING(phoneNumber))
                                                           isValid = NO;
                                                       else if (EV_IS_EMPTY_STRING(password) || password.length < 8)
                                                           isValid = NO;
                                                       else if (![password isEqualToString:passwordConfirmation])
                                                           isValid = NO;
                                                       else if (![agreementBool boolValue])
                                                           isValid = NO;
                                                       return @(isValid);
                                                   }];
    RAC(self.saveButton.enabled) = validFormSignal;
}

#pragma mark - Gesture Handling

- (void)saveButtonTapped {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"name" : self.nameCell.textField.text,
                                   @"email" : self.emailCell.textField.text,
                                   @"phone_number" : self.phoneNumberCell.textField.text,
                                   @"password" : self.passwordCell.textField.text,
                                   @"password_confirmation" : self.passwordConfirmationCell.textField.text }];
    if (self.photo)
        [params setObject:self.photo forKey:@"avatar"];
    
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CREATING ACCOUNT..."];
    
    [EVUser createWithParams:params success:^(EVObject *object) {
        [EVSession createWithEmail:params[@"email"] password:params[@"password"] success:^{
            
            EVUser *me = [[EVUser alloc] initWithDictionary:[EVSession sharedSession].originalDictionary[@"user"]];
            me.password = params[@"password"];
            me.updatedAvatar = self.photo;
            [EVUser setMe:me];
            
            [EVUtilities registerForPushNotifications];
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].postSuccess = ^(void) {
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

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photo = pickedImage;
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVSignUpCellRowCOUNT;
}

- (EVGroupedTableViewCell *)editPhotoCell {
    EVEditPhotoCell *cell = (EVEditPhotoCell *)[super editPhotoCell];
    cell.avatarView.image = self.photo ? self.photo : [EVImages addPhotoIcon];
    return cell;
}

- (EVEditLabelCell *)editLabelCellForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVSignUpCellRowName)
        return self.nameCell;
    else if (indexPath.row == EVSignUpCellRowEmail)
        return self.emailCell;
    else if (indexPath.row == EVSignUpCellRowPhoneNumber)
        return self.phoneNumberCell;
    else if (indexPath.row == EVSignUpCellRowPassword)
        return self.passwordCell;
    else if (indexPath.row == EVSignUpCellRowConfirmPassword)
        return self.passwordConfirmationCell;
    return nil;
}

- (EVEditLabelCell *)createdCellForRow:(EVSignUpCellRow)row {
    EVEditLabelCell *editLabelCell = [[EVEditLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editLabelCell"];
    editLabelCell.textField.returnKeyType = UIReturnKeyNext;
    editLabelCell.textField.delegate = self;
    editLabelCell.tag = row;
    
    if (row == EVSignUpCellRowName) {
        [editLabelCell setTitle:@"Name" placeholder:@"John Smith"];
        self.nameCell = editLabelCell;
    } else if (row == EVSignUpCellRowEmail) {
        [editLabelCell setTitle:@"Email" placeholder:@"example@college.edu"];
        self.emailCell = editLabelCell;
    } else if (row == EVSignUpCellRowPhoneNumber) {
        [editLabelCell setTitle:@"Phone Number" placeholder:@"XXX-XXX-XXXX"];
        self.phoneNumberCell = editLabelCell;
    } else if (row == EVSignUpCellRowPassword) {
        [editLabelCell setTitle:@"Password" placeholder:@"at least 8 characters"];
        editLabelCell.textField.secureTextEntry = YES;
        self.passwordCell = editLabelCell;
    } else if (row == EVSignUpCellRowConfirmPassword) {
        [editLabelCell setTitle:@"Confirm Password" placeholder:@"same as above"];
        editLabelCell.textField.secureTextEntry = YES;
        editLabelCell.textField.returnKeyType = UIReturnKeyDone;
        self.passwordConfirmationCell = editLabelCell;
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
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    return YES;
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = [super tableViewFrame];
    tableFrame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
    return tableFrame;
}

- (CGRect)footerViewFrame {
    CGRect footerFrame = [super footerViewFrame];
    footerFrame.size.height += CHECK_VIEW_HEIGHT*2 + CHECKMARK_BUFFER*2;
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

@end
