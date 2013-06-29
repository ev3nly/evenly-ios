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

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVNavigationBarButton *saveButton;

@property (nonatomic, strong) EVGroupRequestTitleCell *titleCell;
@property (nonatomic, strong) EVGroupRequestMemoCell *memoCell;

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) EVGroupRequestEditAddOptionCell *addOptionCell;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) BOOL needsSaving;

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
        self.cancelButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        self.saveButton = [[EVNavigationBarButton alloc] initWithTitle:@"Save"];
        [self.saveButton addTarget:self action:@selector(saveButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
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
    
    self.needsSaving = NO;
    
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
    [RACAble(self.needsSaving) subscribeNext:^(NSNumber *isValidNumber) {
        self.navigationItem.rightBarButtonItem.enabled = self.needsSaving;
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
    
    [cell.optionNameField.rac_textSignal subscribeNext:^(id x) {
        [self checkIfNeedsSaving];
    }];
    [cell.optionAmountField.rac_textSignal subscribeNext:^(NSString *x) {
        [self checkIfNeedsSaving];
    }];

    return cell;
}

- (void)checkIfNeedsSaving {
    BOOL needsSaving = NO;
    
    for (EVGroupRequestEditAmountCell *cell in self.optionCells) {
        if (!cell.tier)
        {
            if (!EV_IS_EMPTY_STRING(cell.optionAmountField.text)) {
                needsSaving = YES;
                break;
            }
        } 
        else
        {
            NSString *newText = cell.optionNameField.text;
            if (![newText isEqualToString:cell.tier.name]) {
                needsSaving = YES;
                break;
            }
        }
    }
    self.needsSaving = needsSaving;
}

#pragma mark - Button Actions

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    [self.view findAndResignFirstResponder];
}

- (void)deleteButtonPress:(UIButton *)sender {
    EVGroupRequestEditAmountCell *cell = (EVGroupRequestEditAmountCell *)[[sender superview] superview];
    NSInteger index = [self.optionCells indexOfObject:cell];
    [self.tableView beginUpdates];
    [self removeCellAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self checkIfNeedsSaving];
}

#pragma mark - Managing State 

- (void)showSaving {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SAVING..."];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)showSuccess {
    [[EVStatusBarManager sharedManager] setPostSuccess:^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    if (self.delegate)
        [self.delegate editViewControllerMadeChanges:self];
}

- (void)showFailure {
    [[EVStatusBarManager sharedManager] setPostSuccess:^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Updating and Saving

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
                          [[EVStatusBarManager sharedManager] setPostSuccess:^{
                              self.navigationItem.rightBarButtonItem.enabled = YES;
                              [cell setTier:tier];
                          }];
                      } failure:^(NSError *error) {
                          [self showFailure];
                      }];
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

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveButtonPress:(id)sender {
    [self save];
}

- (void)save {

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionCells count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == [self.optionCells count]) {
        cell = self.addOptionCell;
    }
    else {
        cell = [self.optionCells objectAtIndex:indexPath.row];
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
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:0]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
                                  animated:YES];
}

@end
