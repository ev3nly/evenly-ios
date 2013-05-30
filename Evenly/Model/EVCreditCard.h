//
//  EVCreditCard.h
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSource.h"

@interface EVCreditCard : EVFundingSource

@property (nonatomic, strong) NSString *lastFour;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *expirationMonth;
@property (nonatomic, strong) NSString *expirationYear;

//not returned by server
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *cvv;


- (NSComparisonResult)compareByBrandAndLastFour:(EVCreditCard *)otherCard;
- (UIImage *)brandImage;

@end
