//
//  EVCurrencyTextFieldFormatter.h
//  Evenly
//
//  Created by Joseph Hankin on 4/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVCurrencyTextFieldFormatter : NSObject <UITextFieldDelegate>

@property (nonatomic, readonly) NSString *formattedString;

- (void)replaceUnderlyingDetailsWithThoseOfFormatter:(EVCurrencyTextFieldFormatter *)formatter;

@end
