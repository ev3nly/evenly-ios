//
//  EVBankAccount.h
//  Evenly
//
//  Created by Joseph Hankin on 3/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSource.h"

@interface EVBankAccount : EVFundingSource

@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *routingNumber;
@property (nonatomic, strong) NSString *accountNumber;

//not returned by server
@property (nonatomic, strong) NSString *name;

@end
