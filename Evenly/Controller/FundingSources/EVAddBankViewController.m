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
#import "EVCheckingSavingsCell.h"

@interface EVAddBankViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVBankAccount *bankAccount;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) EVNavigationBarButton *saveButton;

@property (nonatomic, strong) EVTitleTextFieldCell *ownerNameCell;
@property (nonatomic, strong) EVTitleTextFieldCell *routingNumberCell;
@property (nonatomic, strong) EVTitleTextFieldCell *accountNumberCell;
@property (nonatomic, strong) EVCheckingSavingsCell *accountTypeCell;

- (void)loadTableView;
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
        self.title = @"Add a Bank";
        self.bankAccount = [[EVBankAccount alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
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
    [self.tableView addReassuringMessage];
    [self.view addSubview:self.tableView];
}

- (void)loadStaticCells {
    EVTitleTextFieldCell *cell;
    NSInteger index = 0;
    
    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Name";
    cell.textField.placeholder = @"John Grey";
    cell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.ownerNameCell = cell;
    self.ownerNameCell.position = EVGroupedTableViewCellPositionTop;
    
    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Routing";
    cell.textField.placeholder = @"123456789";
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.routingNumberCell = cell;
    self.routingNumberCell.position = EVGroupedTableViewCellPositionCenter;
    self.ownerNameCell.textField.next = self.routingNumberCell.textField;
    
    cell = [[EVTitleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Account";
    cell.textField.placeholder = @"123456789";
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    cell.textField.tag = index++;
    cell.textField.delegate = self;
    self.accountNumberCell = cell;
    self.accountNumberCell.position = EVGroupedTableViewCellPositionCenter;
    self.routingNumberCell.textField.next = self.accountNumberCell.textField;

    EVCheckingSavingsCell *checkingSavingsCell = [[EVCheckingSavingsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                              reuseIdentifier:nil];
    checkingSavingsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accountTypeCell = checkingSavingsCell;
    self.accountTypeCell.position = EVGroupedTableViewCellPositionBottom;
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
                                                            self.accountNumberCell.textField.rac_textSignal]
                                                   reduce:^(NSString *ownerName, NSString *routingNumber, NSString *accountNumber) {
                                                       return @([ownerName length] > 0 &&
                                                       [routingNumber length] > 0 && [routingNumber isInteger] &&
                                                       [accountNumber length] > 0 && [accountNumber isInteger]);
                                                   }];
    
    RAC(self.navigationItem.rightBarButtonItem.enabled) = formValidSignal;
}

#pragma mark - Messaging


- (void)setLoading {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Validating Bank Account";
    
    [self.tableView findAndResignFirstResponder];
}

- (void)setError {
    self.navigationItem.leftBarButtonItem.enabled = YES;
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
        if (self.canDismissManually)
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        else
            [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)saveBankAccount {
    [self setLoading];
    
    self.bankAccount.name = self.ownerNameCell.textField.text;
    self.bankAccount.routingNumber = self.routingNumberCell.textField.text;
    self.bankAccount.accountNumber = self.accountNumberCell.textField.text;
    self.bankAccount.type = self.accountTypeCell.savingsButton.checked ? @"savings" : @"checking";
    
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
    UITableViewCell *cell;
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3)
        return nil;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EVTitleTextFieldCell *cell = (EVTitleTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(EVTextField *)textField next]) {
        [[(EVTextField *)textField next] becomeFirstResponder];
        return NO;
    }
    return YES;
}


@end
