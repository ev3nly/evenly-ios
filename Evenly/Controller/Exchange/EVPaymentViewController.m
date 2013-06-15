//
//  EVPaymentViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPaymentViewController.h"
#import "EVPayment.h"

@interface EVPaymentViewController ()

@end

@implementation EVPaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"New Payment";
        self.exchange = [EVPayment new];
    }
    return self;
}

- (void)completeExchangePress:(id)sender
{
    [super completeExchangePress:sender];
}

@end
