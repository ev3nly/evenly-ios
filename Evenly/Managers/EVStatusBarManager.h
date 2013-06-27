//
//  EVStatusBarManager.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVStatusBarProgressView.h"

typedef void(^EVStatusBarManagerCompletionBlock)(void);

@interface EVStatusBarManager : NSObject

+ (EVStatusBarManager *)sharedManager;

@property (nonatomic, strong) EVStatusBarManagerCompletionBlock preSuccess;
@property (nonatomic, strong) EVStatusBarManagerCompletionBlock postSuccess;

- (void)setStatus:(EVStatusBarStatus)status; //default text
- (void)setStatus:(EVStatusBarStatus)status text:(NSString *)text;

- (BOOL)controllersShouldHideDropShadows;

@end
