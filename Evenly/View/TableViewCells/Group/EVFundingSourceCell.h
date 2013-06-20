//
//  EVCreditCardCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@class EVFundingSource;

@interface EVFundingSourceCell : EVGroupedTableViewCell

- (void)setUpWithFundingSource:(EVFundingSource *)fundingSource;

@end
