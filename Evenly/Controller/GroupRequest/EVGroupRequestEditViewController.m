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

#import "EVNavigationBarButton.h"
#import "EVGrayButton.h"

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

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) EVGrayButton *addOptionButton;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) BOOL needsSaving;

@property (nonatomic, strong) NSMutableArray *blockQueue;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (void)doNextBlock;

@end

@implementation EVGroupRequestEditViewController

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = groupRequest;
        self.title = @"Payment Options";
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
        
        self.addOptionButton = [[EVGrayButton alloc] initWithFrame:[self addOptionButtonFrame]];
        [self.addOptionButton addTarget:self action:@selector(addOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.addOptionButton setTitle:@"ADD OPTION" forState:UIControlStateNormal];
        
        self.blockQueue = [NSMutableArray array];
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (CGRect)addOptionButtonFrame {
    return CGRectMake(10, 10, 300, 35);
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
        [cell setEditable:NO];
        [self.optionCells addObject:cell];
    }
    [(EVGroupRequestEditAmountCell *)[self.optionCells objectAtIndex:0] setPosition:EVGroupedTableViewCellPositionTop];
}

- (void)addNewCell {
    EVGroupRequestEditAmountCell *cell = [self configuredCell];
    [cell setEditable:YES];
    [cell.optionNameField setNext:cell.optionAmountField];
    [self.optionCells addObject:cell];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:0]]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
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
        previousCell.optionNameField.next = cell.optionNameField;
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
            previous.optionNameField.next = next.optionNameField;
        else
            previous.optionNameField.next = nil;
    }
    [self.optionCells removeObjectAtIndex:index];
}

#pragma mark - Button Actions

- (void)addOptionButtonPress:(id)sender {
    [self addNewCell];
}

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveButtonPress:(id)sender {
    [self save];
}

#pragma mark - Saving

- (void)save {
    for (EVGroupRequestEditAmountCell *cell in self.optionCells) {
        NSString *amountString = cell.optionAmountField.text;
        NSDecimalNumber *amount = [EVStringUtility amountFromAmountString:amountString];
        
        // Early exit if invalid amount.
        if ([amount floatValue] < EV_MINIMUM_EXCHANGE_AMOUNT) {
            UIAlertView *alert = [UIAlertView alertViewWithTitle:@"Oops" message:@"Amount has to be at least fifty cents." cancelButtonTitle:@"OK" otherButtonTitles:nil onDismiss:nil onCancel:^{
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    [cell.optionAmountField becomeFirstResponder];
                });
            }];
            [alert show];
            
            [self.blockQueue removeAllObjects];
            return;
        }
        
        // Skip any cells that don't need saving.
        if (cell.tier &&
            [cell.tier.price isEqualToNumber:amount] &&
            [cell.tier.name isEqualToString:cell.optionNameField.text])
        {
            continue;
        }
        
        [self.blockQueue addObject:[self blockOperationForCell:cell]];
    }
    
    [self.blockQueue addObject:[self finalBlockOperation]];

    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SAVING..."];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[self operationQueue] setSuspended:NO];
    [self doNextBlock];
}

- (void)doNextBlock {
    if (self.blockQueue.count) {
		[self.operationQueue addOperation:[self.blockQueue objectAtIndex:0]];
		[self.blockQueue removeObjectAtIndex:0];
	}
}

- (void)errorOut {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    [[self operationQueue] setSuspended:YES];
    [self.blockQueue removeAllObjects];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self checkIfNeedsSaving];
}

- (NSBlockOperation *)blockOperationForCell:(EVGroupRequestEditAmountCell *)cell {    
    
    return [NSBlockOperation blockOperationWithBlock:^{
        
        DLog(@"Block for cell %@", cell);
        EVGroupRequestTier *tier = nil;
        if (!cell.tier)
        {
            tier = [[EVGroupRequestTier alloc] init];
            tier.name = cell.optionNameField.text;
            tier.price = [EVStringUtility amountFromAmountString:cell.optionAmountField.text];
        } else {
            tier = cell.tier;
        }
        [self.groupRequest saveTier:tier
                        withSuccess:^(EVGroupRequestTier *tier) {
                            [self doNextBlock];
                        } failure:^(NSError *error) {
                            [self errorOut];
                        }];
    }];
}

- (NSBlockOperation *)finalBlockOperation {
    return [NSBlockOperation blockOperationWithBlock:^{
        DLog(@"Final block");
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [[EVStatusBarManager sharedManager] setPostSuccess:^{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
         }];
        if (self.delegate) {
            [self.delegate editViewControllerMadeChanges:self];
        }

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionCells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.optionCells objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [self.addOptionButton setFrame:[self addOptionButtonFrame]];
    [view addSubview:self.addOptionButton];
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
                                  animated:YES];
}

@end
