//
//  EVDepositViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDepositViewController.h"
#import "EVDepositCell.h"
#import "EVWithdrawal.h"
#import "EVBankAccount.h"
#import "EVBlueButton.h"
#import "EVPrivacyNotice.h"
#import "EVCurrencyTextFieldFormatter.h"

#import "EVAddBankViewController.h"

#define EV_DEPOSIT_MARGIN 10.0
#define EV_DEPOSIT_BALANCE_PANE_HEIGHT 96.0
#define EV_DEPOSIT_CELL_HEIGHT 44.0
#define EV_DEPOSIT_BUTTON_HEIGHT 44.0

@interface EVDepositViewController ()

@property (nonatomic, weak) EVCIA *cia;

@property (nonatomic, strong) UIImageView *balancePane;
@property (nonatomic, strong) UILabel *balanceLabel;

@property (nonatomic, strong) UIImageView *cellContainer;
@property (nonatomic, strong) EVDepositCell *amountCell;
@property (nonatomic, strong) EVDepositCell *bankCell;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) EVBlueButton *depositButton;
@property (nonatomic, strong) EVPrivacyNotice *privacyNotice;

@property (nonatomic, strong) EVBankAccount *chosenAccount;

@property (nonatomic, strong) EVWithdrawal *withdrawal;
@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) BOOL validForm;

- (void)loadBalancePane;
- (void)loadPickerView;
- (void)loadCells;
- (void)loadDepositButton;
- (void)loadReassuringMessage;
- (void)setUpReactions;

@end

@implementation EVDepositViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Deposit";
        self.withdrawal = [[EVWithdrawal alloc] init];
        self.currencyFormatter = [[EVCurrencyTextFieldFormatter alloc] init];
        self.cia = [EVCIA sharedInstance];
        self.chosenAccount = self.cia.activeBankAccount;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankAccountsDidLoad:) name:EVCIAUpdatedBankAccountsNotification object:nil];

    [self loadBalancePane];
    [self loadPickerView];
    [self loadCells];
    [self loadDepositButton];
    [self loadReassuringMessage];
    [self setUpReactions];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)loadPickerView {
    self.pickerView = [UIPickerView new];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.frame = CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
}

- (void)loadBalancePane {
    self.balancePane = [[UIImageView alloc] initWithFrame:CGRectMake(EV_DEPOSIT_MARGIN,
                                                                EV_DEPOSIT_MARGIN,
                                                                self.view.frame.size.width - 2*EV_DEPOSIT_MARGIN,
                                                                EV_DEPOSIT_BALANCE_PANE_HEIGHT)];
    self.balancePane.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.balancePane.image = [EVImages resizableTombstoneBackground];
    [self.view addSubview:self.balancePane];
    
    self.balanceLabel = [[UILabel alloc] initWithFrame:self.balancePane.bounds];
    self.balanceLabel.backgroundColor = [UIColor clearColor];
    self.balanceLabel.textColor = [UIColor blackColor];
    self.balanceLabel.textAlignment = NSTextAlignmentCenter;
    self.balanceLabel.font = [EVFont blackFontOfSize:48];
    
    [self.balanceLabel setText:[EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance]];

    [self.balancePane addSubview:self.balanceLabel];
}

- (void)loadCells {
    self.cellContainer = [[UIImageView alloc] initWithFrame:CGRectMake(EV_DEPOSIT_MARGIN,
                                                                       CGRectGetMaxY(self.balancePane.frame) + EV_DEPOSIT_MARGIN,
                                                                       self.view.frame.size.width - 2*EV_DEPOSIT_MARGIN,
                                                                       2*EV_DEPOSIT_CELL_HEIGHT)];
    self.cellContainer.userInteractionEnabled = YES;
    self.cellContainer.image = [EVImages resizableTombstoneBackground];
    [self.view addSubview:self.cellContainer];
    
    UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0, EV_DEPOSIT_CELL_HEIGHT, self.cellContainer.frame.size.width, [EVUtilities scaledDividerHeight])];
    [stripe setBackgroundColor:[EVColor newsfeedStripeColor]];
    [self.cellContainer addSubview:stripe];
    
    self.amountCell = [[EVDepositCell alloc] initWithFrame:CGRectMake(0, 0, self.cellContainer.frame.size.width, EV_DEPOSIT_CELL_HEIGHT)];
    self.amountCell.label.text = @"I want to deposit...";
    self.amountCell.textField.placeholder = @"$0.00";
    self.amountCell.textField.delegate = self;
    [self.amountCell setNeedsLayout];
    [self.cellContainer addSubview:self.amountCell];
    
    self.bankCell = [[EVDepositCell alloc] initWithFrame:CGRectMake(0, EV_DEPOSIT_CELL_HEIGHT, self.cellContainer.frame.size.width, EV_DEPOSIT_CELL_HEIGHT)];
    self.bankCell.label.text = @"Into my...";
    if (self.cia.activeBankAccount)
        self.bankCell.textField.text = [self.cia.activeBankAccount bankName];
    else
        self.bankCell.textField.text = @"Loading...";
    self.bankCell.textField.inputView = self.pickerView;
    [self.bankCell setNeedsLayout];
    [self.cellContainer addSubview:self.bankCell];

}

- (void)loadDepositButton {
    self.depositButton = [[EVBlueButton alloc] initWithFrame:CGRectMake(EV_DEPOSIT_MARGIN,
                                                                        CGRectGetMaxY(self.cellContainer.frame) + EV_DEPOSIT_MARGIN,
                                                                        self.view.frame.size.width - 2*EV_DEPOSIT_MARGIN,
                                                                        EV_DEPOSIT_BUTTON_HEIGHT)];
    [self.depositButton addTarget:self action:@selector(depositButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.depositButton];
    [self.depositButton setEnabled:NO];
}

- (void)loadReassuringMessage {
    self.privacyNotice = [[EVPrivacyNotice alloc] initWithFrame:CGRectMake(EV_DEPOSIT_MARGIN,
                                                                           CGRectGetMaxY(self.depositButton.frame) + EV_DEPOSIT_MARGIN,
                                                                           self.view.frame.size.width - 2*EV_DEPOSIT_MARGIN,
                                                                           EV_DEPOSIT_BUTTON_HEIGHT)];
    self.privacyNotice.label.text = @"100% Free.  Transfers take 1-2 days.";
    [self.view addSubview:self.privacyNotice];
}

- (void)setUpReactions {
    // Balance label
    [RACAble(self.cia.me.balance) subscribeNext:^(NSDecimalNumber *balance) {
        [self.balanceLabel setText:[EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance]];
    }];
    
    // Bank text
    [RACAble(self.chosenAccount) subscribeNext:^(EVBankAccount *bank) {
        if (bank) {
            self.bankCell.textField.text = bank.bankName;
            self.bankCell.textField.enabled = YES;
            NSString *amountText = self.amountCell.textField.text;
            if (EV_IS_EMPTY_STRING(amountText))
                amountText = self.amountCell.textField.placeholder;
            [self.depositButton setTitle:[NSString stringWithFormat:@"DEPOSIT %@", amountText] forState:UIControlStateNormal];
            [self.amountCell.textField setEnabled:YES];
        }
        else {
            if (self.cia.loadingBankAccounts)
                self.bankCell.textField.text = @"Loading...";
            else {
                self.bankCell.textField.text = @"No bank account added.";
                [self.depositButton setTitle:@"ADD BANK ACCOUNT" forState:UIControlStateNormal];
                [self.depositButton setEnabled:YES];
                [self.amountCell.textField setEnabled:NO];
            }
            self.bankCell.textField.enabled = NO;
        }
        [self.bankCell setNeedsLayout];
    }];
   
    // Button text
    [self.amountCell.textField.rac_textSignal subscribeNext:^(NSString *amountText) {
        if (EV_IS_EMPTY_STRING(amountText))
            amountText = self.amountCell.textField.placeholder;
        [self.depositButton setTitle:[NSString stringWithFormat:@"DEPOSIT %@", amountText] forState:UIControlStateNormal];
    }];
    
    // Form validity
    RAC(self.validForm) = [RACSignal combineLatest:@[self.amountCell.textField.rac_textSignal,
                                                     RACAble(self.chosenAccount)]
                                            reduce:^(NSString *amountText, EVBankAccount *account) {
                                                
                                                if (account == nil)
                                                    return @(NO);
                                                
                                                amountText = [amountText stringByReplacingOccurrencesOfString:@"$" withString:@""];
                                                if ([amountText length] == 0)
                                                    return @(NO);
                                                
                                                if ([amountText floatValue] < EV_MINIMUM_DEPOSIT_AMOUNT)
                                                    return @(NO);
                                                
                                                BOOL valid = NO;
                                                NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:amountText];
                                                self.withdrawal.amount = amount;
                                                
                                                if ([amount compare:[EVCIA sharedInstance].me.balance] == NSOrderedDescending)
                                                    valid = NO;
                                                else
                                                    valid = YES;
                                                
                                                return @(valid);
                                                
                                            }];
    [RACAble(self.validForm) subscribeNext:^(NSNumber *boolNumber) {
        [self.depositButton setEnabled:[boolNumber boolValue]];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.chosenAccount = self.cia.activeBankAccount;
}

#pragma mark - Button Actions

- (void)depositButtonPress:(id)sender {
    if (self.chosenAccount)
    {
        [self deposit];
    }
    else
    {
        [self presentAddBankController];
    }
}

- (void)deposit {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"DEPOSITING MONEY..."];
    [self.view findAndResignFirstResponder];
    
    self.withdrawal.bankAccount = self.chosenAccount;
    [self.withdrawal saveWithSuccess:^{
        
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
            self.cia.me.balance = [self.cia.me.balance decimalNumberBySubtracting:self.withdrawal.amount];
            self.validForm = NO;
            self.amountCell.textField.text = nil;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            }];
        };
    } failure:^(NSError *error){
        
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        
    }];
}

- (void)presentAddBankController {
    EVAddBankViewController *addBankController = [[EVAddBankViewController alloc] init];
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:addBankController];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    if ([self.amountCell.textField isFirstResponder])
        [self.amountCell.textField resignFirstResponder];
    else if ([self.bankCell.textField isFirstResponder])
        [self.bankCell.textField resignFirstResponder];
    else {
        CGPoint tapPoint = [recognizer locationInView:self.balancePane];
        if (CGRectContainsPoint(self.balancePane.frame, tapPoint))
            [self.amountCell.textField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountCell.textField) {
        [self.currencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
        [self.amountCell.textField setText:self.currencyFormatter.formattedString];
        [self.amountCell.textField sendActionsForControlEvents:UIControlEventEditingChanged]; // for rac_textSignal
        return NO;
    }
    return YES;
}

#pragma mark - Picker DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.cia loadingBankAccounts])
        return 1;
    return [self.cia.bankAccounts count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.cia loadingBankAccounts])
        return @"Loading...";
    return [[self.cia.bankAccounts objectAtIndex:row] bankName];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenAccount = [self.cia.bankAccounts objectAtIndex:row];
}

#pragma mark - Notifications

- (void)bankAccountsDidLoad:(NSNotification *)notification {
    [self.pickerView reloadAllComponents];
    self.chosenAccount = self.cia.activeBankAccount;
}

@end
