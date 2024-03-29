//
//  EVHistoryRewardViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 8/8/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryAbstractViewController.h"
#import "EVReward.h"

typedef enum {
    EVHistoryRewardRowAmount,
    EVHistoryRewardRowDate,
    EVHistoryRewardRowCOUNT
} EVHistoryRewardRow;

@interface EVHistoryRewardViewController : EVHistoryAbstractViewController

- (id)initWithReward:(EVReward *)reward;

@end
