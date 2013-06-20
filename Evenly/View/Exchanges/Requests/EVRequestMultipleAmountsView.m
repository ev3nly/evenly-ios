//
//  EVRequestMultipleAmountsView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestMultipleAmountsView.h"
#import "EVGroupRequestAmountCell.h"

#define HEADER_LABEL_HEIGHT 48.0
#define NAVIGATION_BAR_OFFSET 44.0

#define INITIAL_NUMBER_OF_OPTIONS 2

@interface EVRequestMultipleAmountsView ()

@property (nonatomic, strong) NSMutableArray *optionCells;
@property (nonatomic, strong) EVGroupRequestAddOptionCell *addOptionCell;
@property (nonatomic, strong) NSArray *tiers;
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
        self.tiers = [NSArray array];
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

- (void)loadSegmentedControl {
    self.segmentedControl = [[EVSegmentedControl alloc] initWithItems:@[@"The Same Amount", @"Different Amounts"]];
    [self.segmentedControl setFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame), self.frame.size.width, 44)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentedControl];
}

- (void)loadSingleAmountView {
    self.singleAmountView = [[EVRequestBigAmountView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.segmentedControl.frame),
                                                                     self.frame.size.width,
                                                                     EV_DEFAULT_KEYBOARD_HEIGHT - CGRectGetMaxY(self.segmentedControl.frame))];
    [self addSubview:self.singleAmountView];    
}

- (void)loadMultipleAmountsView {
    DLog(@"Self.frame: %@", NSStringFromCGRect(self.frame));
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
}

- (void)loadCells {
    self.optionCells = [NSMutableArray array];
    
    for (int i=0; i<INITIAL_NUMBER_OF_OPTIONS; i++) {
        [self.optionCells addObject:[self configuredCell]];
    }
    self.addOptionCell = [[EVGroupRequestAddOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addOptionCell"];
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
}

#pragma mark - Controls

- (void)segmentedControlChanged:(EVSegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self addSubview:self.singleAmountView];
        [self.multipleAmountsView removeFromSuperview];
    } else {
        [self addSubview:self.multipleAmountsView];
        [self.singleAmountView removeFromSuperview];
    }
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionCells count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.optionCells count])
    {
        return self.addOptionCell;
    }
    
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"HERE");
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.optionCells count]) {
        [self.optionCells addObject:[self configuredCell]];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.optionCells count]-1 inSection:0]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
