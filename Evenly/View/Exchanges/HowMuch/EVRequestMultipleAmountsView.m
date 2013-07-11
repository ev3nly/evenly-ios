//
//  EVRequestMultipleAmountsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestMultipleAmountsView.h"
#import "EVGroupRequestAmountCell.h"
#import "EVGroupRequestTier.h"
#import "EVGrayButton.h"

#import "EVKeyboardTracker.h"

#define HEADER_LABEL_HEIGHT 48.0
#define NAVIGATION_BAR_OFFSET 44.0

#define INITIAL_NUMBER_OF_OPTIONS 1

@interface EVRequestMultipleAmountsView ()

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) EVGrayButton *addOptionButton;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic) BOOL isValid;

- (void)loadHeaderLabel;
- (void)loadSegmentedControl;
- (void)loadSingleAmountView;
- (void)loadMultipleAmountsView;

@end

@implementation EVRequestMultipleAmountsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadHeaderLabel];
        [self loadSegmentedControl];
        [self loadSingleAmountView];
        [self loadCells];

        [self loadMultipleAmountsView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadHeaderLabel {
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, HEADER_LABEL_HEIGHT)];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [EVFont blackFontOfSize:16];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.text = @"Each person owes me...";
    [self addSubview:self.headerLabel];
}

- (void)loadSegmentedControl {
    self.segmentedControl = [[EVMultipleAmountsSegmentedControl alloc] initWithItems:@[@"The Same Amount", @"Different Amounts"]];
    [self.segmentedControl setFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame), self.frame.size.width, 44)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentedControl];
}

- (void)loadSingleAmountView {
    self.singleAmountView = [[EVExchangeBigAmountView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.segmentedControl.frame),
                                                                     self.frame.size.width,
                                                                     EV_DEFAULT_KEYBOARD_HEIGHT - CGRectGetMaxY(self.segmentedControl.frame))];
    [self addSubview:self.singleAmountView];
    [self.singleAmountView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        [self validate];
    }];
}

- (void)loadMultipleAmountsView {
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.multipleAmountsView = tvc.tableView;
    self.multipleAmountsView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.segmentedControl.frame),
                                                self.frame.size.width,
                                                self.frame.size.height - CGRectGetMaxY(self.segmentedControl.frame));
    self.multipleAmountsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.multipleAmountsView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(self.segmentedControl.frame),
                                                                             self.frame.size.width,
                                                                             self.frame.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - NAVIGATION_BAR_OFFSET - CGRectGetMaxY(self.segmentedControl.frame))];
    self.multipleAmountsView.delegate = self;
    self.multipleAmountsView.dataSource = self;
    self.multipleAmountsView.editing = YES;
    self.multipleAmountsView.allowsSelectionDuringEditing = YES;
    self.multipleAmountsView.separatorColor = [UIColor clearColor];
    self.multipleAmountsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.addOptionButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(20, 5, 280, 35)];
    [self.addOptionButton setTitle:@"Add Option" forState:UIControlStateNormal];
    [self.addOptionButton addTarget:self action:@selector(addOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self.tableFooterView addSubview:self.addOptionButton];
    
    self.multipleAmountsView.tableFooterView = self.tableFooterView;
}

- (void)loadCells {
    self.optionCells = [NSMutableArray array];
    
    for (int i=0; i<INITIAL_NUMBER_OF_OPTIONS; i++) {
        [self.optionCells addObject:[self configuredCell]];
    }
}

- (EVGroupRequestAmountCell *)configuredCell {
    EVGroupRequestAmountCell *cell = [[EVGroupRequestAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:@"optionCell"];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    EVGroupRequestAmountCell *lastCell = [self.optionCells lastObject];
    if (lastCell)
    {
        lastCell.optionAmountField.next = cell.optionNameField;
    }
    
    [cell.optionAmountField.rac_textSignal subscribeNext:^(NSString *x) {
        [self validate];
    }];
    return cell;
}

- (void)validate {
    if (self.segmentedControl.selectedSegmentIndex == EVRequestAmountsSingle)
    {
        float amount = [[EVStringUtility amountFromAmountString:self.singleAmountView.amountField.text] floatValue];
        self.isValid = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT);
    }
    else
    {            
        BOOL isAllGood = ([self.optionCells count] > 0);
        for (EVGroupRequestAmountCell *cell in self.optionCells) {
            float amount = [[EVStringUtility amountFromAmountString:cell.optionAmountField.text] floatValue];
            if (amount < EV_MINIMUM_EXCHANGE_AMOUNT)
            {
                isAllGood = NO;
                break;
            }
        }
        self.isValid = isAllGood;
    }
}

- (NSArray *)tiers {
    NSArray *tiers = nil;
    if (self.segmentedControl.selectedSegmentIndex == EVRequestAmountsSingle)
    {
        EVGroupRequestTier *tier = [[EVGroupRequestTier alloc] init];
        tier.price = [EVStringUtility amountFromAmountString:self.singleAmountView.amountField.text];
        tiers = @[ tier ];
    }
    else
    {
        NSMutableArray *tmpTiers = [[NSMutableArray alloc] initWithCapacity:[self.optionCells count]];
        for (EVGroupRequestAmountCell *cell in self.optionCells) {
            EVGroupRequestTier *tier = [[EVGroupRequestTier alloc] init];
            tier.price = [EVStringUtility amountFromAmountString:cell.optionAmountField.text];
            tier.name = cell.optionNameField.text;
            [tmpTiers addObject:tier];
        }
        tiers = [NSArray arrayWithArray:tmpTiers];
    }
    return tiers;    
}

#pragma mark - Controls

- (void)segmentedControlChanged:(EVSegmentedControl *)sender {
    if (sender.selectedSegmentIndex == EVRequestAmountsSingle) {
        [self addSubview:self.singleAmountView];
        [self.multipleAmountsView removeFromSuperview];
    } else {
        self.multipleAmountsView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.segmentedControl.frame),
                                                    self.frame.size.width,
                                                    self.frame.size.height - NAVIGATION_BAR_OFFSET - CGRectGetMaxY(self.segmentedControl.frame));
        [self addSubview:self.multipleAmountsView];
        [self.singleAmountView removeFromSuperview];
    }
    [self validate];
}

- (void)deleteButtonPress:(UIButton *)sender {
    EVGroupRequestAmountCell *cell = (EVGroupRequestAmountCell *)[sender superview];
    NSInteger index = [self.optionCells indexOfObject:cell];
    [self removeCellAtIndex:index];
    [self.multipleAmountsView beginUpdates];
    [self.multipleAmountsView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.multipleAmountsView endUpdates];
}

- (void)removeCellAtIndex:(NSInteger)index {
    EVGroupRequestAmountCell *previous, *goner, *next = nil;
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
    [self validate];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionCells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.optionCells objectAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.optionCells count])
        return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.optionCells moveObjectFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    // Don't allow user to move a cell to the "Add Option" row
    if (proposedDestinationIndexPath.row == ([self.optionCells count]))
        return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row - 1 inSection:proposedDestinationIndexPath.section];
    
    return proposedDestinationIndexPath;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)addOptionButtonPress:(id)sender {
    [self.optionCells addObject:[self configuredCell]];
    [self.multipleAmountsView beginUpdates];
    [self.multipleAmountsView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:0]]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.multipleAmountsView endUpdates];
    [self validate];
    
    [[self.optionCells lastObject] becomeFirstResponder];
}

#pragma mark - First Responder

- (BOOL)isFirstResponder {
    BOOL isFirstResponder = [super isFirstResponder];
    for (EVGroupRequestAmountCell *cell in self.optionCells) {
        isFirstResponder |= [cell isFirstResponder];
    }
    return isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [[self.optionCells lastObject] becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self.optionCells makeObjectsPerformSelector:@selector(resignFirstResponder)];
    return YES;
}

#pragma mark - Keyboard Observation

- (void)keyboardWillAppear:(NSNotification *)notification {
    [self.multipleAmountsView setContentInset:UIEdgeInsetsMake(0, 0, EV_DEFAULT_KEYBOARD_HEIGHT, 0)];
}

- (void)keyboardWillDisappear:(NSNotification *)notification {
    [self.multipleAmountsView setContentInset:UIEdgeInsetsZero];
}


@end
