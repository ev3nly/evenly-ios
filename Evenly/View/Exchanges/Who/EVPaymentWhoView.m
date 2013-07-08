//
//  EVPaymentWhoView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPaymentWhoView.h"

@implementation EVPaymentWhoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addContact:(EVObject<EVExchangeable> *)contact {
    if (![[self recipients] containsObject:contact])
    {
        for (id obj in [self recipients])
        {
            [self.toField removeTokenWithRepresentedObject:obj];
        }
        [self.toField addTokenWithTitle:contact.name representedObject:contact];
    }
    self.toField.textField.text = nil;
}

@end
