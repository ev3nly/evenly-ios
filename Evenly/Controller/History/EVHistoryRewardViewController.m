//
//  EVHistoryRewardViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 8/8/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryRewardViewController.h"

@interface EVHistoryRewardViewController ()

@property (nonatomic, strong) EVReward *reward;

@end

@implementation EVHistoryRewardViewController

- (id)initWithReward:(EVReward *)reward {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.reward = reward;
        self.title = @"Reward Details";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setLoading:self.reward.loading];
    [self.tableView setTableFooterView:(self.reward.loading ? nil : self.footerView)];
}

- (NSString *)fieldTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fieldText = nil;
    switch (indexPath.row) {
        case EVHistoryRewardRowAmount:
            fieldText = @"Amount:";
            break;
        case EVHistoryRewardRowDate:
            fieldText = @"Date:";
            break;
        default:
            break;
    }
    return fieldText;
}


- (NSString *)valueTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fieldText = nil;
    switch (indexPath.row) {
        case EVHistoryRewardRowAmount:
            fieldText = [EVStringUtility amountStringForAmount:self.reward.selectedAmount];
            break;
        case EVHistoryRewardRowDate:
            fieldText = [NSDateFormatter localizedStringFromDate:self.reward.createdAt
                                                       dateStyle:NSDateFormatterMediumStyle
                                                       timeStyle:NSDateFormatterMediumStyle];
            break;
        default:
            break;
    }
    return fieldText;
}

- (NSString *)emailSubjectLine {
    return [NSString stringWithFormat:@"Reward %@", self.reward.dbid];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.reward.loading)
        return 0;
    return EVHistoryRewardRowCOUNT;
}



@end
