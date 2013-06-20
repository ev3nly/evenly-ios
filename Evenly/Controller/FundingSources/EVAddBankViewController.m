//
//  EVAddBankViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAddBankViewController.h"
#import "EVBankAccount.h"
#import "EVTitleTextFieldCell.h"
#import "EVNavigationBarButton.h"

@interface EVAddBankViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) EVBankAccount *bankAccount;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) EVNavigationBarButton *saveButton;

@property (nonatomic, strong) EVTitleTextFieldCell *ownerNameCell;
@property (nonatomic, strong) EVTitleTextFieldCell *routingNumberCell;
@property (nonatomic, strong) EVTitleTextFieldCell *accountNumberCell;
@property (nonatomic, strong) EVTitleTextFieldCell *accountTypeCell;

- (void)loadTableView;
- (void)loadPickerView;
- (void)loadStaticCells;
- (void)loadSaveButton;
- (void)setUpReactions;

- (void)saveBankAccount;
- (void)setLoading;
- (void)setError;
- (void)setSuccess;

@end

@implementation EVAddBankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Add Bank Account";
        self.bankAccount = [[EVBankAccount alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    [self loadPickerView];
    [self loadStaticCells];
    [self loadSaveButton];
    [self setUpReactions];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   0.0f,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.backgroundView = nil;
    [self.view addSubview:self.tableView];
}

- (void)loadPickerView {
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
}

- (void)loadStaticCells {
    EVTitleTextFieldCell *cell;
    NSInteger index = 0;
    
    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Account Owner";
    cell.textField.placeholder = @"John Grey";
    cell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.ownerNameCell = cell;
    self.ownerNameCell.position = EVGroupedTableViewCellPositionTop;
    
    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Routing Number";
    cell.textField.placeholder = @"123456789";
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.routingNumberCell = cell;
    self.routingNumberCell.position = EVGroupedTableViewCellPositionCenter;
    self.ownerNameCell.textField.next = self.routingNumberCell.textField;
    
    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Account Number";
    cell.textField.placeholder = @"123456789";
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.accountNumberCell = cell;
    self.accountNumberCell.position = EVGroupedTableViewCellPositionCenter;
    self.routingNumberCell.textField.next = self.accountNumberCell.textField;

    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Type";
    cell.textField.placeholder = @"Checking";
    cell.textField.inputView = self.pickerView;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.accountTypeCell = cell;
    self.accountTypeCell.position = EVGroupedTableViewCellPositionBottom;
    self.accountNumberCell.textField.next = self.accountTypeCell.textField;
}

- (UITextField *)textFieldAtIndex:(NSInteger)index {
    EVTitleTextFieldCell *cell = (EVTitleTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell.textField;
}

- (void)loadSaveButton {
    self.saveButton = [[EVNavigationBarButton alloc] initWithTitle:@"Save"];
    [self.saveButton addTarget:self action:@selector(saveBankAccount) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setUpReactions {
    RACSignal *formValidSignal = [RACSignal combineLatest:@[self.ownerNameCell.textField.rac_textSignal,
                                                            self.routingNumberCell.textField.rac_textSignal,
                                                            self.accountNumberCell.textField.rac_textSignal,
                                                            self.accountTypeCell.textField.rac_textSignal]
                                                   reduce:^(NSString *ownerName, NSString *routingNumber, NSString *accountNumber, NSString *accountType) {
                                                       return @([ownerName length] > 0 &&
                                                       [routingNumber length] > 0 && [routingNumber isInteger] &&
                                                       [accountNumber length] > 0 && [accountNumber isInteger] &&
                                                       ([accountType isEqualToString:@"Checking"] || [accountType isEqualToString:@"Savings"]));
                                                   }];
    
    RAC(self.navigationItem.rightBarButtonItem.enabled) = formValidSignal;
}

#pragma mark - Messaging


- (void)setLoading {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Validating Bank Account";
    
    [self.tableView findAndResignFirstResponder];
}

- (void)setError {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Error";
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), queue, ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)setSuccess {
    self.hud.labelText = @"Success!";
    self.hud.mode = MBProgressHUDModeText;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), queue, ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)saveBankAccount {
    [self setLoading];
    
    self.bankAccount.name = self.ownerNameCell.textField.text;
    self.bankAccount.routingNumber = self.routingNumberCell.textField.text;
    self.bankAccount.accountNumber = self.accountNumberCell.textField.text;
    self.bankAccount.type = self.accountTypeCell.textField.text;
    
    [self.bankAccount tokenizeWithSuccess:^{
        
        self.hud.labelText = @"Saving Bank Account";
        
        [self.bankAccount saveWithSuccess:^{
            [[EVCIA sharedInstance] reloadBankAccountsWithCompletion:NULL];
            [self setSuccess];
        } failure:^(NSError *error) {
            [self setError];
        }];
        
    } failure:^(NSError *error) {
        [self setError];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVTitleTextFieldCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = self.ownerNameCell;
            break;
        case 1:
            cell = self.routingNumberCell;
            break;
        case 2:
            cell = self.accountNumberCell;
            break;
        case 3:
            cell = self.accountTypeCell;
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EVTitleTextFieldCell *cell = (EVTitleTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    switch (row) {
        case 0:
            title = @"Checking";
            break;
        case 1:
            title = @"Savings";
            break;
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    EVTitleTextFieldCell *cell = (EVTitleTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [cell.textField setText:title];
    [cell.textField sendActionsForControlEvents:UIControlEventEditingChanged]; // for rac_textSignal to fire
}

#pragma mark - UITextFieldDelegate

- (UITextField *)accountTypeField {
    return [self textFieldAtIndex:3];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == [self accountTypeField]) {
        [self pickerView:self.pickerView didSelectRow:[self.pickerView selectedRowInComponent:0] inComponent:0];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(EVTextField *)textField next]) {
        [[(EVTextField *)textField next] becomeFirstResponder];
        return NO;
    }
    return YES;
}


@end
