//
//  EVWithdrawal.h
//  Evenly
//
//  Created by Joseph Hankin on 3/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVBankAccount;

@interface EVWithdrawal : EVObject

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *bankName;

@property (nonatomic, strong) EVBankAccount *bankAccount;

@end
