//
//  EVRequestHowMuchView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestHowMuchView.h"
#import "EVGroupRequestAmountCell.h"
#import "EVGroupRequestTier.h"

#define HEADER_LABEL_HEIGHT 40.0
#define NAVIGATION_BAR_OFFSET ([EVUtilities userHasIOS7] ? 0 : 44)

#define INITIAL_NUMBER_OF_OPTIONS 1

#define Y_SPACING 10.0

#define INFO_LABEL_X_MARGIN 20
#define INFO_LABEL_Y_MARGIN 5
#define INFO_LABEL_HEIGHT ([EVUtilities userHasIOS7] ? 30 : 20)

#define MULTI_ADD_OPTION_X_MARGIN 20
#define MULTI_ADD_OPTION_WIDTH 280

@interface EVGroupRequestHowMuchView ()

@property (nonatomic, strong) UIView *multiAddOptionButtonContainer;
@property (nonatomic, strong) EVGrayButton *multiAddOptionButton;

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) NSMutableIndexSet *expandedCells;

@property (nonatomic) BOOL isValid;

- (void)loadHeaderLabel;
- (void)loadSingleAmountView;
- (void)loadMultipleAmountsView;
- (void)loadAddOptionButton;
- (void)loadTierAssignmentView;

@end

@implementation EVGroupRequestHowMuchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadHeaderLabel];
        [self loadSingleAmountView];
        [self loadCells];
        [self loadMultipleAmountsView];
        [self loadAddOptionButton];
        [self loadTierAssignmentView];
        
        self.backgroundColor = [EVColor darkColor];
        
        self.expandedCells = [[NSMutableIndexSet alloc] init];

        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        self.tapRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.tapRecognizer];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    }
    return self;
}

#pragma mark - View Loading

- (void)loadHeaderLabel {
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, HEADER_LABEL_HEIGHT)];
    self.headerLabel.backgroundColor = [EVColor creamColor];
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [EVFont blackFontOfSize:16];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.text = @"Each person owes me...";
    self.headerLabel.userInteractionEnabled = YES;
    self.headerLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.headerLabel];
}

- (void)loadSingleAmountView {
    self.singleAmountView = [[EVGroupRequestSingleAmountView alloc] initWithFrame:[self singleAmountViewFrame]];
    [self insertSubview:self.singleAmountView belowSubview:self.headerLabel];
    self.singleAmountView.backgroundColor = [EVColor creamColor];
    [self.singleAmountView.bigAmountView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        [self validate];
    }];
    [self.singleAmountView.addOptionButton addTarget:self
                                              action:@selector(addOptionFromSingleAmountPress:)
                                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadMultipleAmountsView {
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.multipleAmountsView = tvc.tableView;
    self.multipleAmountsView.frame = [self multipleAmountsViewOffscreenFrame];
    self.multipleAmountsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.multipleAmountsView.delegate = self;
    self.multipleAmountsView.dataSource = self;
    self.multipleAmountsView.separatorColor = [UIColor clearColor];
    self.multipleAmountsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.multipleAmountsView.backgroundColor = [EVColor creamColor];
    
    EVLabel *label = [[EVLabel alloc] initWithFrame:CGRectMake(INFO_LABEL_X_MARGIN,
                                                               INFO_LABEL_Y_MARGIN,
                                                               self.frame.size.width - 2*INFO_LABEL_X_MARGIN,
                                                               INFO_LABEL_HEIGHT)];
    label.font = [EVFont defaultFontOfSize:14];
    label.textColor = [EVColor lightLabelColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = [EVStringUtility multiAmountInfoMessage];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.adjustLetterSpacingToFitWidth = YES;
    
    self.footerLabel = label;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, INFO_LABEL_HEIGHT)];
    [containerView addSubview:label];
    self.multipleAmountsView.tableFooterView = containerView;
    self.footerView = containerView;
    
    [self insertSubview:self.multipleAmountsView belowSubview:self.headerLabel];
}

- (void)loadAddOptionButton {
    
    self.multiAddOptionButtonContainer = [[UIView alloc] initWithFrame:[self addOptionButtonContainerOffscreenFrame]];
    self.multiAddOptionButtonContainer.backgroundColor = [EVColor creamColor];
    [self addSubview:self.multiAddOptionButtonContainer];
    
    self.multiAddOptionButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(MULTI_ADD_OPTION_X_MARGIN,
                                                                               Y_SPACING,
                                                                               MULTI_ADD_OPTION_WIDTH,
                                                                               ADD_OPTION_BUTTON_HEIGHT)];
    [self.multiAddOptionButton setTitle:[EVStringUtility addAdditionalOptionButtonTitle] forState:UIControlStateNormal];
    [self.multiAddOptionButton addTarget:self action:@selector(addOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.multiAddOptionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.multiAddOptionButtonContainer addSubview:self.multiAddOptionButton];
    
    [self.multipleAmountsView setOrigin:CGPointMake(self.multipleAmountsView.frame.origin.x, -self.multipleAmountsView.frame.size.height)];
    [self.multiAddOptionButtonContainer setOrigin:CGPointMake(self.multiAddOptionButtonContainer.frame.origin.x, self.frame.size.height)];
}

- (void)loadTierAssignmentView {
    self.tierAssignmentManager = [[EVGroupRequestTierAssignmentManager alloc] initWithGroupRequest:self.groupRequest];
    self.tierAssignmentManager.delegate = self;
    
    self.tierAssignmentView = [[EVGroupRequestTierAssignmentView alloc] initWithFrame:CGRectMake(0,
                                                                                                 self.frame.size.height,
                                                                                                 self.frame.size.width,
                                                                                                 EV_DEFAULT_KEYBOARD_HEIGHT)];
    self.tierAssignmentView.delegate = self.tierAssignmentManager;
    self.tierAssignmentView.dataSource = self.tierAssignmentManager;
    [self addSubview:self.tierAssignmentView];
}

- (void)loadCells {
    self.optionCells = [NSMutableArray array];
    
    for (int i=0; i<INITIAL_NUMBER_OF_OPTIONS; i++) {
        [self.optionCells addObject:[self configuredCell]];
    }
    EVGroupRequestAmountCell *firstCell = [self.optionCells firstObject];
    [firstCell addTopStripe];
}

- (EVGroupRequestAmountCell *)configuredCell {
    EVGroupRequestAmountCell *cell = [[EVGroupRequestAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:@"optionCell"];
    
    cell.handleDeletePress = ^(EVGroupRequestAmountCell *cell) {
        [self handleDeleteForCell:cell];
    };
    cell.handleSelectFriendsPress = ^(EVGroupRequestAmountCell *cell) {
        [self handleSelectFriendsForCell:cell];
    };
    cell.handleArrowPress = ^(EVGroupRequestAmountCell *cell) {
        [self handleArrowForCell:cell];
    };
    
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

#pragma mark - Property Overrides

- (void)setGroupRequest:(EVGroupRequest *)groupRequest {
    _groupRequest = groupRequest;
    self.tierAssignmentManager.groupRequest = groupRequest;
    [self.tierAssignmentView reloadData];
}

#pragma mark - Transition

- (void)setShowingMultipleOptions:(BOOL)showing animated:(BOOL)animated completion:(void (^)(void))completion {
    _showingMultipleOptions = showing;
    
    EVGroupRequestAmountCell *firstCell = [self.optionCells objectAtIndex:0];
    if (showing) {
        [firstCell.optionAmountField setText:self.singleAmountView.bigAmountView.amountField.text];
        [firstCell.currencyFormatter replaceUnderlyingDetailsWithThoseOfFormatter:self.singleAmountView.bigAmountView.currencyFormatter];
    } else {
        [self.singleAmountView.bigAmountView.amountField setText:firstCell.optionAmountField.text];
        [self.singleAmountView.bigAmountView.currencyFormatter replaceUnderlyingDetailsWithThoseOfFormatter:firstCell.currencyFormatter];
    }
    
    if (!animated)
    {
        if (showing) {
            [self.singleAmountView removeFromSuperview];
            [self addSubview:self.multipleAmountsView];
            [self addSubview:self.multiAddOptionButton];
        } else  {
            [self.multipleAmountsView removeFromSuperview];
            [self.multiAddOptionButton removeFromSuperview];
            [self addSubview:self.singleAmountView];
        }
    }
    else
    {
        if (showing) {
            [self animateFromSingleToMultiWithCompletion:completion];
        } else {
            [self animateFromMultiToSingleWithCompletion:completion];
        }
    }
    
    [self validate];
}

- (void)animateFromSingleToMultiWithCompletion:(void (^)(void))completion {
    
    // These blocks are created backwards, because computers are stupid.
    // First, the single amount view goes away, then the multiple amounts view appears,
    // then the add option button comes in from the bottom.    
    void (^addOptionButtonBlock)(void) = ^{
        [self.multiAddOptionButtonContainer bounceAnimationToFrame:[self addOptionButtonContainerFrame]
                                                   initialDuration:(float)0.15
                                                   durationDamping:(float)0.55
                                                   distanceDamping:(float)0.05
                                                        completion:^{
                                                       if (completion)
                                                           completion();
                                                   }];
    };
    
    void (^multipleAmountsBlock)(void) = ^{
        [self.multipleAmountsView bounceAnimationToFrame:[self multipleAmountsViewFrame]
                                         initialDuration:(float)0.25
                                         durationDamping:(float)0.65
                                         distanceDamping:(float)0.05
                                              completion:addOptionButtonBlock];
    };

    [self.singleAmountView bounceAnimationToFrame:[self singleAmountViewOffscreenFrame]
                                  initialDuration:(float)0.25
                                  durationDamping:(float)0.45
                                  distanceDamping:(float)0.05
                                       completion:multipleAmountsBlock];
}

- (void)animateFromMultiToSingleWithCompletion:(void (^)(void))completion {
    
    // These blocks are created backwards, because computers are stupid.
    // First, the add option button disappers, then the multiple amounts view,
    // and then the single amount view comes in.
    void (^singleAmountBlock)(void) = ^{
        [self.singleAmountView bounceAnimationToFrame:[self singleAmountViewFrame]
                                      initialDuration:(float)0.25
                                      durationDamping:(float)0.65
                                      distanceDamping:(float)0.05
                                           completion:^{
                                          if (completion)
                                              completion();
                                      }];
    };
    
    [self.multipleAmountsView bounceAnimationToFrame:[self multipleAmountsViewOffscreenFrame]
                                     initialDuration:(float)0.25
                                     durationDamping:(float)0.45
                                     distanceDamping:(float)0.05
                                          completion:singleAmountBlock];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.multiAddOptionButtonContainer.frame = [self addOptionButtonContainerOffscreenFrame];
                     } completion:nil];
}

- (void)showTierAssignmentView {
    [self.tierAssignmentView reloadData];
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.tierAssignmentView setFrame:CGRectMake(0,
                                                                      self.frame.size.height - self.tierAssignmentView.frame.size.height - NAVIGATION_BAR_OFFSET,
                                                                      self.tierAssignmentView.frame.size.width,
                                                                      self.tierAssignmentView.frame.size.height)];
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideTierAssignmentView {
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.tierAssignmentView setFrame:CGRectMake(0,
                                                                      self.frame.size.height,
                                                                      self.tierAssignmentView.frame.size.width,
                                                                      self.tierAssignmentView.frame.size.height)];
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Model

- (void)validate {
    if (self.optionCells.count == 1)
    {
        float amount = [[EVStringUtility amountFromAmountString:self.singleAmountView.bigAmountView.amountField.text] floatValue];
        //        self.isValid = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT);
        self.isValid = (amount > 0.0f);
    }
    else
    {
        self.isValid = ![self hasTierBelowMinimum];
    }
}

- (BOOL)isMissingAmount {
    BOOL isAllGood = ([self.optionCells count] > 0);
    for (EVGroupRequestAmountCell *cell in self.optionCells) {
        if (EV_IS_EMPTY_STRING(cell.optionAmountField.text))
        {
            isAllGood = NO;
            break;
        }
    }
    return !isAllGood;
}

- (BOOL)hasTierBelowMinimum {
    if ([self showingMultipleOptions])
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
        return !isAllGood;
    }
    else
    {
        float amount = [[EVStringUtility amountFromAmountString:self.singleAmountView.bigAmountView.amountField.text] floatValue];
        return (amount < EV_MINIMUM_DEPOSIT_AMOUNT);
    }
}

- (BOOL)hasUnassignedMembers {
    if (![self showingMultipleOptions])
        return NO;
    
    return [self.tierAssignmentManager hasUnassignedMembers];
}


- (NSArray *)tiers {
    NSArray *tiers = nil;
    if (self.optionCells.count == 1)
    {
        EVGroupRequestTier *tier = [[EVGroupRequestTier alloc] init];
        tier.price = [EVStringUtility amountFromAmountString:self.singleAmountView.bigAmountView.amountField.text];
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

- (NSArray *)assignments {
    NSMutableArray *assignments = [NSMutableArray array];
    
    // If there's only one tier, assign all members to it.
    if (self.optionCells.count == 1)
    {
        for (int i=0; i<[self.groupRequest.initialMembers count]; i++) {
            [assignments addObject:@{ @"tier_index" : @(0), @"member_index" : @(i) }];
        }
    }
    else
    {
        int tierIndex = 0;
        int memberIndex;
        for (NSArray *tierArray in self.tierAssignmentManager.tierMemberships) {
            for (EVObject<EVExchangeable> *member in tierArray) {
                memberIndex = [self.groupRequest.initialMembers indexOfObject:member];
                [assignments addObject:@{
                 @"member_index": @(memberIndex),
                 @"tier_index" : @(tierIndex)
                 }];
            }
            tierIndex++;
        }
    }
    return [NSArray arrayWithArray:assignments];
}

#pragma mark - Button Actions

- (void)addOptionFromSingleAmountPress:(id)sender {
    [self setShowingMultipleOptions:YES animated:YES completion:NULL];
    [self addCell];
}

- (void)addOptionButtonPress:(id)sender {
    [self addCell];
}

- (void)handleDeleteForCell:(EVGroupRequestAmountCell *)cell {
    NSInteger index = [self.optionCells indexOfObject:cell];
    if (index >= [self.optionCells count])
        return;
    [self removeCellAtIndex:index];
    if ([self.optionCells count] > 1)
    {
        [self.multipleAmountsView beginUpdates];
        [self.multipleAmountsView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0]]
                                        withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.multipleAmountsView endUpdates];
    }
}

- (void)handleSelectFriendsForCell:(EVGroupRequestAmountCell *)cell {
    if ([self.groupRequest.initialMembers count] == 0) {
        [self flashMessage:@"Go back and add friends first!"
                   inFrame:self.headerLabel.bounds
              withDuration:2.0f];
        return;
    }
    
    NSInteger index = [self.optionCells indexOfObject:cell];
    [self.tierAssignmentManager setRepresentedTierIndex:index];
    [self showTierAssignmentView];    
}

- (void)handleArrowForCell:(EVGroupRequestAmountCell *)cell {
    NSInteger index = [self.optionCells indexOfObject:cell];
    if ([self.expandedCells containsIndex:index]) {
        [self.expandedCells removeIndex:index];
    } else {
        [self.expandedCells addIndex:index];
    }
    
    [self.multipleAmountsView beginUpdates];
    [self.multipleAmountsView endUpdates];
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    if (CGRectContainsPoint(self.tierAssignmentView.frame, [recognizer locationInView:recognizer.view]))
        return;
    
    [self.singleAmountView.bigAmountView resignFirstResponder];
    [self.optionCells makeObjectsPerformSelector:@selector(resignFirstResponder)];
    [self hideTierAssignmentView];
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
    [self.tierAssignmentManager.tierMemberships removeObjectAtIndex:index];
    
    if (self.optionCells.count == 1) {
        __weak EVGroupRequestHowMuchView *weakSelf = self;
        [self setShowingMultipleOptions:NO animated:YES completion:^{
            [weakSelf.multipleAmountsView reloadData];
        }];
    }
    [self validate];
}

#pragma mark - UITableViewDataSource

- (void)addCell {
    [self.optionCells addObject:[self configuredCell]];
    
    [self.tierAssignmentManager.tierMemberships addObject:[NSMutableArray array]];

    [self.multipleAmountsView beginUpdates];
    [self.multipleAmountsView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.multipleAmountsView endUpdates];
    [self validate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionCells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.expandedCells containsIndex:indexPath.row]) {
        return [EVGroupRequestAmountCell expandedHeight];
    } else {
        return [EVGroupRequestAmountCell standardHeight];
    }
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

#pragma mark - EVGroupRequestTierAssignmentManagerDelegate

- (void)tierAssignmentManagerDidUpdateMemberships:(EVGroupRequestTierAssignmentManager *)manager {
    int i=0;
    for (EVGroupRequestAmountCell *cell in self.optionCells) {
        NSArray *memberships = [[manager tierMemberships] objectAtIndex:i];
        NSString *title = nil;
        if ([memberships count] == 0)
            title = @"SELECT FRIENDS";
        else if ([memberships count] == 1)
            title = @"1 FRIEND";
        else
            title = [NSString stringWithFormat:@"%d FRIENDS", [memberships count]];
        [cell.friendsButton setTitle:title forState:UIControlStateNormal];
        i++;
    }
}

#pragma mark - Keyboard Observation

- (void)keyboardWillAppear:(NSNotification *)notification {
    [self.multipleAmountsView setContentInset:UIEdgeInsetsMake(0, 0, EV_DEFAULT_KEYBOARD_HEIGHT, 0)];
}

- (void)keyboardWillDisappear:(NSNotification *)notification {
    [self.multipleAmountsView setContentInset:UIEdgeInsetsZero];
}

#pragma mark - First Responder

- (BOOL)isFirstResponder {
    return self.singleAmountView.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.singleAmountView becomeFirstResponder];
}

#pragma mark - Frames

- (CGRect)singleAmountViewFrame {
    return CGRectMake(0,
                      HEADER_LABEL_HEIGHT,
                      self.frame.size.width,
                      self.frame.size.height - CGRectGetMaxY(self.headerLabel.frame) - NAVIGATION_BAR_OFFSET);
}

- (CGRect)singleAmountViewOffscreenFrame {
    CGFloat height = self.frame.size.height - CGRectGetMaxY(self.headerLabel.frame) - NAVIGATION_BAR_OFFSET;
    return CGRectMake(0,
                      -height - NAVIGATION_BAR_OFFSET,
                      self.frame.size.width,
                      height);
}

- (CGRect)multipleAmountsViewFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.headerLabel.frame),
                      self.frame.size.width,
                      self.frame.size.height - CGRectGetMaxY(self.headerLabel.frame) - NAVIGATION_BAR_OFFSET -  ADD_OPTION_BUTTON_HEIGHT - 2*Y_SPACING);
}

- (CGRect)multipleAmountsViewOffscreenFrame {
    CGFloat height = self.frame.size.height - CGRectGetMaxY(self.headerLabel.frame) - NAVIGATION_BAR_OFFSET -  ADD_OPTION_BUTTON_HEIGHT - 2*Y_SPACING;
    return CGRectMake(0,
                      -height - NAVIGATION_BAR_OFFSET,
                      self.frame.size.width,
                      height);
}

- (CGRect)addOptionButtonContainerFrame {
    return CGRectMake(0,
                      self.frame.size.height - NAVIGATION_BAR_OFFSET - ADD_OPTION_BUTTON_HEIGHT - 2*Y_SPACING,
                      self.frame.size.width,
                      ADD_OPTION_BUTTON_HEIGHT + 2*Y_SPACING);
}

- (CGRect)addOptionButtonContainerOffscreenFrame {
    return CGRectMake(0,
                      self.frame.size.height,
                      self.frame.size.width,
                      ADD_OPTION_BUTTON_HEIGHT + 2*Y_SPACING);
}

@end
