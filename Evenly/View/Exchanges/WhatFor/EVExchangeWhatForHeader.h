//
//  EVExchangeWhatForHeader.h
//  Evenly
//
//  Created by Joseph Hankin on 7/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVObject.h"
#import "EVUser.h"

@interface EVExchangeWhatForHeader : UIView

+ (id)paymentHeaderForPerson:(EVObject <EVExchangeable>*)person amount:(NSDecimalNumber *)amount;
+ (id)requestHeaderForPerson:(EVObject <EVExchangeable>*)person amount:(NSDecimalNumber *)amount;
+ (id)groupRequestHeaderForPeople:(NSArray *)people amounts:(NSArray *)amounts;

@end
