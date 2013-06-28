//
//  EVGroupRequestEditViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestEditViewController.h"
#import "EVRequestMultipleDetailsView.h"
#import "EVGroupRequestEditAmountCell.h"
#import "EVGroupedTableViewCell.h"
#import "EVGroupRequestTier.h"

#import "EVGroupRequestTitleCell.h"
#import "EVGroupRequestMemoCell.h"
#import "EVNavigationBarButton.h"

#import "EVTextField.h"
#import "EVPlaceholderTextView.h"

#import "EVFormRow.h"
#import "EVKeyboardTracker.h"

#import "UIAlertView+MKBlockAdditions.h"
#import "UIActionSheet+MKBlockAdditions.h"

#define FORM_LABEL_MARGIN 10
#define FORM_LABEL_MAX_X 90

@interface EVGroupRequestEditViewController ()

@property (nonatomic, strong) EVNavigationBarButton *doneButton;

@property (nonatomic, strong) EVGroupRequestTitleCell *titleCell;
@property (nonatomic, strong) EVGroupRequestMemoCell *memoCell;

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) EVGroupRequestEditAddOptionCell *addOptionCell;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) BOOL isValid;

@end

@implementation EVGroupRequestEditViewController

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = groupRequest;
        self.title = @"Edit Request";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.doneButton = [[EVNavigationBarButton alloc] initWithTitle:@"Done"];
        [self.doneButton addTarget:self action:@selector(doneButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTitleRow];
    [self loadMemoRow];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[EVGroupRequestEditAmountCell class] forCellReuseIdentifier:@"amountCell"];
    [self.view addSubview:self.tableView];
    
    [self loadCells];
    [self setUpReactions];
    [self loadGestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cellBeganEditing:)
                                                 name:EVGroupRequestEditAmountCellBeganEditing
                                               object:nil];
}

- (void)loadTitleRow {
    self.titleCell = [[EVGroupRequestTitleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"titleCell"];
    self.titleCell.fieldLabel.text = @"Title";
    self.titleCell.textField.text = self.groupRequest.title;
    self.titleCell.textField.placeholder = @"Title";
    __weak EVGroupRequestEditViewController *weakSelf = self;
    self.titleCell.handleTextChange = ^(NSString *text) {
        [weakSelf updateTitle:text];
    };
}

- (void)loadMemoRow {
    
    self.memoCell = [[EVGroupRequestMemoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"memoCell"];
    self.memoCell.fieldLabel.text = @"Description";
    self.memoCell.textField.text = self.groupRequest.memo;
    self.memoCell.textField.placeholder = [EVStringUtility groupRequestDescriptionPlaceholder];
    __weak EVGroupRequestEditViewController *weakSelf = self;
    self.memoCell.handleTextChange = ^(NSString *text) {
        [weakSelf updateMemo:text];
    };
}

- (void)loadCells {
    self.optionCells = [NSMutableArray array];
    
    for (EVGroupRequestTier *tier in self.groupRequest.tiers) {
        EVGroupRequestEditAmountCell *cell = [self configuredCell];
        [cell setTier:tier];
        [cell setEditable:[self.groupRequest isTierEditable:tier]];
        [self.optionCells addObject:cell];
    }
    [(EVGroupRequestEditAmountCell *)[self.optionCells objectAtIndex:0] setPosition:EVGroupedTableViewCellPositionTop];
    self.addOptionCell = [[EVGroupRequestEditAddOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addOptionCell"];
}

- (void)loadGestureRecognizer {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
}

- (void)setUpReactions {
    [RACAble(self.isValid) subscribeNext:^(NSNumber *isValidNumber) {
        self.navigationItem.rightBarButtonItem.enabled = self.isValid;
    }];
}

- (EVGroupRequestEditAmountCell *)configuredCell {
    EVGroupRequestEditAmountCell *cell = [[EVGroupRequestEditAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:@"optionCell"];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    cell.position = EVGroupedTableViewCellPositionCenter;
    
    EVGroupRequestEditAmountCell *previousCell = [self.optionCells lastObject];
    if (previousCell)
    {
        previousCell.optionAmountField.next = cell.optionNameField;
    }
    
    [cell.optionAmountField.rac_textSignal subscribeNext:^(NSString *x) {
        [self validate];
    }];
    
    __weak EVGroupRequestEditViewController *weakSelf = self;
    __weak EVGroupRequestEditAmountCell *weakCell = cell;
    cell.handleTextChange = ^(EVTextField *textField) {
        [weakSelf updateDataFromCell:weakCell textFieldThatResigned:textField];
    };
    return cell;
}

- (void)validate {
    
    if (EV_IS_EMPTY_STRING(self.titleCell.textField.text)) {
        self.isValid = NO;
        return;
    }
    
    BOOL isAllGood = YES;
    
    for (EVGroupRequestEditAmountCell *cell in self.optionCells) {
        float amount = [[EVStringUtility amountFromAmountString:cell.optionAmountField.text] floatValue];
        if (amount < EV_MINIMUM_EXCHANGE_AMOUNT)
        {
            isAllGood = NO;
            break;
        }
    }
    self.isValid = isAllGood;
}

#pragma mark - Button Actions

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    [self.view findAndResignFirstResponder];
}

- (void)deleteButtonPress:(UIButton *)sender {
    EVGroupRequestEditAmountCell *cell = (EVGroupRequestEditAmountCell *)[[sender superview] superview];
    NSInteger index = [self.optionCells indexOfObject:cell];
    
    [UIActionSheet actionSheetWithTitle:@"Are you sure?"
                                message:nil
                 destructiveButtonTitle:@"Yes"
                                buttons:@[ @"No" ]
                             showInView:self.view
                              onDismiss:^(int buttonIndex) { [self deleteDataFromCell:cell]; }
                               onCancel:NULL];

    [self.tableView beginUpdates];
    [self removeCellAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:1]]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)removeCellAtIndex:(NSInteger)index {
    EVGroupRequestEditAmountCell *previous, *goner, *next = nil;
    if (index > 0)
        previous = [self.optionCells objectAtIndex:index-1];
    goner = [self.optionCells objectAtIndex:index];
    if ([self.optionCells count] > index+1)
        next = [self.optionCells objectAtIndex:index+1];
    
    if (previous)
    {
        if (next)
            previous.optionAmountField.next = next.optionNameField;
        else
            previous.optionAmountField.next = nil;
    }
    [self.optionCells removeObjectAtIndex:index];
}

- (void)doneButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Managing State 

- (void)showSaving {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SAVING..."];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)showSuccess {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    if (self.delegate)
        [self.delegate editViewControllerMadeChanges:self];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)showFailure {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Updating and Saving

- (void)updateTitle:(NSString *)title {
    NSString *previousTitle = self.groupRequest.title;
    [self showSaving];
    self.groupRequest.title = title;
    [self.groupRequest updateWithSuccess:^{
        [self showSuccess];
    } failure:^(NSError *error) {
        [self showFailure];
        self.groupRequest.title = previousTitle;
        self.titleCell.textField.text = previousTitle;
    }];
}

- (void)updateMemo:(NSString *)memo {
    NSString *previousMemo = self.groupRequest.memo;
    [self showSaving];
    self.groupRequest.memo = memo;
    [self.groupRequest updateWithSuccess:^{
        [self showSuccess];
    } failure:^(NSError *error) {
        [self showFailure];
        self.groupRequest.memo = previousMemo;
        self.titleCell.textField.text = previousMemo;
    }];
}

- (void)updateDataFromCell:(EVGroupRequestEditAmountCell *)cell textFieldThatResigned:(EVTextField *)textField {
    NSString *amountString = cell.optionAmountField.text;
    NSDecimalNumber *amount = [EVStringUtility amountFromAmountString:amountString];
    
    // Early exit if invalid amount.
    if ([amount floatValue] < EV_MINIMUM_EXCHANGE_AMOUNT) {
        if (textField == cell.optionAmountField)
        {
            UIAlertView *alert = [UIAlertView alertViewWithTitle:@"Oops" message:@"Amount has to be at least fifty cents." cancelButtonTitle:@"OK" otherButtonTitles:nil onDismiss:nil onCancel:^{
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    [cell.optionAmountField becomeFirstResponder];                    
                });
            }];
            [alert show];
        }
        return;
    }
    
    EVGroupRequestTier *tier = nil;
    if (cell.tier)
    {
        tier = cell.tier;
    }
    else
    {
        tier = [[EVGroupRequestTier alloc] init];
    }
    tier.name = cell.optionNameField.text;
    tier.price = amount;
    [self showSaving];
    [self.groupRequest saveTier:tier
                      withSuccess:^(EVGroupRequestTier *tier) {
                          [self showSuccess];
                          [[EVStatusBarManager sharedManager] setCompletion:^{
                              [cell setTier:tier];
                          }];
                      } failure:^(NSError *error) {
                          [self showFailure];
                      }];
}

- (void)deleteDataFromCell:(EVGroupRequestEditAmountCell *)cell {
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0.0;
    return 30.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 2;

    return [self.optionCells count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            return 44;
        } else if (indexPath.row == 1) {
            return 74;
        }
    }
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            cell = self.titleCell;
        } else if (indexPath.row == 1) {
            cell = self.memoCell;
        }
    }
    else {
        if (indexPath.row == [self.optionCells count]) {
            cell = self.addOptionCell;
        }
        else {
            cell = [self.optionCells objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.optionCells count]) {
        EVGroupRequestEditAmountCell *cell = [self configuredCell];
        [self.optionCells addObject:cell];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:1]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, self.view.frame.size.width - 36, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [EVColor lightLabelColor];
    label.font = [EVFont blackFontOfSize:15];
    label.text = @"Payment Options";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view addSubview:label];
    return view;
}

#pragma mark - Handling Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, EV_DEFAULT_KEYBOARD_HEIGHT + 20, 0);
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
}

- (void)cellBeganEditing:(NSNotification *)notification {
    EVGroupRequestEditAmountCell *cell = [notification object];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
}

@end
