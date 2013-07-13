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
#define NAVIGATION_BAR_OFFSET 44.0



#define INITIAL_NUMBER_OF_OPTIONS 1

@interface EVGroupRequestHowMuchView ()

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) NSMutableIndexSet *expandedCells;
@property (nonatomic) BOOL isValid;

- (void)loadHeaderLabel;
- (void)loadSingleAmountView;
- (void)loadMultipleAmountsView;

- (void)loadHintLabel;
- (void)loadAddOptionButton;

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
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
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

- (void)loadSingleAmountView {
    self.singleAmountView = [[EVGroupRequestSingleAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.headerLabel.frame) - 44.0)];
    [self addSubview:self.singleAmountView];
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
    self.multipleAmountsView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.headerLabel.frame),
                                                self.frame.size.width,
                                                self.frame.size.height - CGRectGetMaxY(self.headerLabel.frame));
    self.multipleAmountsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    //    self.multipleAmountsView = [[UITableView alloc] initWithFrame:CGRectMake(0,
    //                                                                             CGRectGetMaxY(self.headerLabel.frame),
    //                                                                             self.frame.size.width,
    //                                                                             self.frame.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - NAVIGATION_BAR_OFFSET - CGRectGetMaxY(self.headerLabel.frame))];
    self.multipleAmountsView.delegate = self;
    self.multipleAmountsView.dataSource = self;
    self.multipleAmountsView.separatorColor = [UIColor clearColor];
    self.multipleAmountsView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [cell.friendsButton addTarget:self action:@selector(friendsButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.arrowButton addTarget:self action:@selector(arrowButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark - Transition

- (void)setShowingMultipleOptions:(BOOL)showing animated:(BOOL)animated {
    _showingMultipleOptions = showing;
    if (showing) {
        [self.singleAmountView removeFromSuperview];
        [self addSubview:self.multipleAmountsView];
    } else  {
        [self.multipleAmountsView removeFromSuperview];
        [self addSubview:self.singleAmountView];
    }
    
    [self validate];
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


#pragma mark - Button Actions

- (void)addOptionFromSingleAmountPress:(id)sender {
    [self setShowingMultipleOptions:YES animated:YES];
    [self addCell];
}

- (void)addOptionButtonPress:(id)sender {
    [self addCell];
}

- (void)deleteButtonPress:(UIButton *)sender {
    EVGroupRequestAmountCell *cell = (EVGroupRequestAmountCell *)[[sender superview] superview];
    NSInteger index = [self.optionCells indexOfObject:cell];
    [self removeCellAtIndex:index];
    [self.multipleAmountsView beginUpdates];
    [self.multipleAmountsView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.multipleAmountsView endUpdates];
}

- (void)friendsButtonPress:(UIButton *)sender {
    EVGroupRequestAmountCell *cell = (EVGroupRequestAmountCell *)[[sender superview] superview];

}

- (void)arrowButtonPress:(UIButton *)sender {
    
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    [self.singleAmountView.bigAmountView resignFirstResponder];
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
    
    if (self.optionCells.count == 1) {
        [self setShowingMultipleOptions:NO animated:YES];
    }
    [self validate];
}

#pragma mark - UITableViewDataSource

- (void)addCell {
    [self.optionCells addObject:[self configuredCell]];
    [self.multipleAmountsView beginUpdates];
    [self.multipleAmountsView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.multipleAmountsView endUpdates];
    [self validate];
    
    [[self.optionCells lastObject] becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionCells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
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

@end
