//
//  EVStatusBarProgressView.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EVStatusBarStatusNone,
    EVStatusBarStatusInProgress,
    EVStatusBarStatusFailure,
    EVStatusBarStatusSuccess
} EVStatusBarStatus;

@interface EVStatusBarProgressView : UIView

@property (nonatomic, assign) EVStatusBarStatus status;

- (void)setStatus:(EVStatusBarStatus)status text:(NSString *)text;

@end
