//
//  EVWalletNotification.h
//  Evenly
//
//  Created by Joseph Hankin on 8/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVWalletNotification : EVObject

@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *bodyText;
@property (nonatomic, strong) UIImage *avatar;

+ (instancetype)unconfirmedNotification;

- (NSAttributedString *)attributedText;

@end

@interface EVUnconfirmedWalletNotification : EVWalletNotification

@end