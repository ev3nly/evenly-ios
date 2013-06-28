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

#define FORM_LABEL_MARGIN 10
#define FORM_LABEL_MAX_X 90

@interface EVGroupRequestEditViewController ()

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVNavigationBarButton *saveButton;

@property (nonatomic, strong) EVGroupRequestTitleCell *titleCell;
@property (nonatomic, strong) EVGroupRequestMemoCell *memoCell;

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) EVGroupRequestEditAddOptionCell *addOptionCell;
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
}

- (void)loadMemoRow {
    
    self.memoCell = [[EVGroupRequestMemoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"memoCell"];
    self.memoCell.fieldLabel.text = @"Description";
    self.memoCell.textField.text = self.groupRequest.memo;
    self.memoCell.textField.placeholder = [EVStringUtility groupRequestDescriptionPlaceholder];
}

- (void)loadCells {
    self.optionCells = [NSMutableArray array];
    
    for (EVGroupRequestTier *tier in self.groupRequest.tiers) {
        EVGroupRequestEditAmountCell *cell = [self configuredCell];
        cell.optionNameField.text = tier.name;
        cell.optionAmountField.text = [EVStringUtility amountStringForAmount:tier.price];
        [cell setEditable:[self.groupRequest isTierEditable:tier]];
        [self.optionCells addObject:cell];
    }
    [(EVGroupRequestEditAmountCell *)[self.optionCells objectAtIndex:0] setPosition:EVGroupedTableViewCellPositionTop];
    self.addOptionCell = [[EVGroupRequestEditAddOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addOptionCell"];
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
        previousCell.position = EVGroupedTableViewCellPositionBottom;
    }
    
    [cell.optionAmountField.rac_textSignal subscribeNext:^(NSString *x) {
        [self validate];
    }];
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

- (void)keyboardWillShow:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, EV_DEFAULT_KEYBOARD_HEIGHT + 20, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)cellBeganEditing:(NSNotification *)notification {
    EVGroupRequestEditAmountCell *cell = [notification object];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
}

- (void)deleteButtonPress:(UIButton *)sender {
    
    EVGroupRequestEditAmountCell *cell = (EVGroupRequestEditAmountCell *)[[sender superview] superview];
    NSInteger index = [self.optionCells indexOfObject:cell];
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

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveButtonPress:(id)sender {
    [self save];
}

- (void)save {
    BOOL needsToSaveRequest = NO;
    BOOL needsToSaveTiers = NO;
        
    if (![self.titleCell.textField.text isEqualToString:self.groupRequest.title] ||
        ![self.memoCell.textField.text isEqualToString:self.groupRequest.memo])
    {
        needsToSaveRequest = YES;
        self.groupRequest.title = self.titleCell.textField.text;
        self.groupRequest.memo = self.memoCell.textField.text;
    }
    
    NSMutableArray *tiersToUpdate = [NSMutableArray array];
    NSMutableArray *tiersToAdd = [NSMutableArray array];
    NSMutableArray *tiersToDelete = [NSMutableArray array];
    int i = 0;
    for ( ; i<self.optionCells.count; i++) {
        EVGroupRequestEditAmountCell *cell = [self.optionCells objectAtIndex:i];
        EVGroupRequestTier *tier = nil;
        if (self.groupRequest.tiers.count > i) {
            tier = [self.groupRequest.tiers objectAtIndex:i];
        }
        NSMutableDictionary *tierDictionary = [NSMutableDictionary dictionaryWithObject:[[EVStringUtility amountFromAmountString:cell.optionAmountField.text] stringValue]
                                                                                 forKey:@"price"];
        if (!EV_IS_EMPTY_STRING(cell.optionNameField.text)) {
            [tierDictionary setObject:cell.optionNameField.text forKey:@"name"];
        }
        if (tier) {
            [tierDictionary setObject:tier forKey:@"tier"];
            [tiersToUpdate addObject:tierDictionary];
        } else {
            [tiersToAdd addObject:tierDictionary];
        }
    }
    
    for ( ; i<self.groupRequest.tiers.count; i++) {
        EVGroupRequestTier *tier = [self.groupRequest.tiers objectAtIndex:i];
        [tiersToDelete addObject:@{ @"tier" : tier }];
    }
    
    needsToSaveTiers = ([tiersToUpdate count] > 0 || [tiersToAdd count] > 0 || [tiersToDelete count] > 0);
    
    __weak EVGroupRequestEditViewController *weakSelf = self;
    
    void (^tiersBlock)(void) = ^{
        [weakSelf updateTiers:tiersToUpdate withCompletion:^{
            [weakSelf addTiers:tiersToAdd withCompletion:^{
                [weakSelf deleteTiers:tiersToDelete withCompletion:^{
                    
                }];
            }];
        }];
    };
}

- (void)updateTiers:(NSArray *)tiers withCompletion:(void (^)(void))completion {
    
}

- (void)addTiers:(NSArray *)tiers withCompletion:(void (^)(void))completion {
    
}

- (void)deleteTiers:(NSArray *)tiers withCompletion:(void (^)(void))completion {
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.optionCells count]) {
        [self.optionCells addObject:[self configuredCell]];
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
@end
