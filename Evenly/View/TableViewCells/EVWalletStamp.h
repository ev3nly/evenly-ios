//
//  EVWalletStamp.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVWalletStamp : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGFloat maxWidth;

- (id)initWithText:(NSString *)text maxWidth:(CGFloat)maxWidth;

@end
