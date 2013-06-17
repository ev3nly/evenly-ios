//
//  EVAddCardViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "PKView.h"

@interface EVAddCardViewController : EVViewController<PKViewDelegate>

@property (nonatomic) BOOL isDebitCard;

@end
