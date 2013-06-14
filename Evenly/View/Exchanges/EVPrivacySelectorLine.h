//
//  EVPrivacySelectorLine.h
//  Evenly
//
//  Created by Justin Brunet on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVUser.h"
#import "EVTapGestureRecognizer.h"
#import "ReactiveCocoa.h"

@interface EVPrivacySelectorLine : UIView

@property (nonatomic, assign) EVPrivacySetting setting;
@property (nonatomic, strong) UIImageView *privacyImageView;
@property (nonatomic, strong) UILabel *label;

- (id)initWithFrame:(CGRect)frame andSetting:(EVPrivacySetting)setting;
- (UIColor *)labelColor;

- (void)handleTouchUpInside;
- (void)setHighlighted:(BOOL)highlighted;

- (UIImage *)imageForSetting:(EVPrivacySetting)setting;
- (NSString *)textForSetting:(EVPrivacySetting)setting;

- (CGRect)imageViewFrame;
- (CGRect)labelFrame;

@end
