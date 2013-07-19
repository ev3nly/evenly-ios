//
//  EVCheckmarkButton.h
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVTapGestureRecognizer.h"

@interface EVCheckmarkButton : UIControl <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImageView *check;

@property (nonatomic) CGFloat xMargin;
@property (nonatomic) CGFloat checkLabelBuffer;

- (id)initWithText:(NSString *)text;
- (void)fadeBetweenChecks;

@end
