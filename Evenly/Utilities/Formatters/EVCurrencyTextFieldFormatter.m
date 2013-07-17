//
//  EVCurrencyTextFieldFormatter.m
//  Evenly
//
//  Created by Joseph Hankin on 4/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCurrencyTextFieldFormatter.h"

@interface EVCurrencyTextFieldFormatter ()

@property (nonatomic, strong) NSString *amountBackingStore;
@property (nonatomic, strong) NSString *formattedString;

@end

@implementation EVCurrencyTextFieldFormatter

- (id)init {
    self = [super init];
    if (self) {
        self.amountBackingStore = @"";
    }
    return self;
}

- (void)replaceUnderlyingDetailsWithThoseOfFormatter:(EVCurrencyTextFieldFormatter *)formatter {
    self.amountBackingStore = formatter.amountBackingStore;
    self.formattedString = formatter.formattedString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent deletion when no amount exists.
    if (self.amountBackingStore.length == 0 && range.length > 0)
        return NO;
    
    // Update the amount backing store by adding or deleting from the end.
    self.amountBackingStore = [self.amountBackingStore stringByReplacingCharactersInRange:NSMakeRange(self.amountBackingStore.length - range.length, range.length) withString:string];
    NSString *stringToShow = nil;
    
    // Case 1: We only have cents.
    if (self.amountBackingStore.length < 3)
    {
        if (self.amountBackingStore.length == 0)
            stringToShow = @"$0.00";
        else
            stringToShow = [NSString stringWithFormat:@"$0.%02d", [self.amountBackingStore intValue]];
    }
    // Case 2: We have dollars and cents.
    else
    {
        stringToShow = [self.amountBackingStore stringByReplacingCharactersInRange:NSMakeRange(self.amountBackingStore.length - 2, 0) withString:@"."];
        stringToShow = [NSString stringWithFormat:@"$%@", stringToShow];
    }
    
    self.formattedString = stringToShow;
    return NO;
}

@end
