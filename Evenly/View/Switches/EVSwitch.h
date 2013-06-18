//
//  EVSwitch.h
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVSwitch;

@protocol EVSwitchDelegate <NSObject>

@optional
- (void)switchControl:(EVSwitch *)switchControl willChangeStateTo:(BOOL)onOff animationDuration:(NSTimeInterval)duration;
- (void)switchControl:(EVSwitch *)switchControl didChangeStateTo:(BOOL)onOff;

@end

@interface EVSwitch : UIControl

@property (nonatomic, getter = isOn) BOOL on;
@property (nonatomic, weak) id<EVSwitchDelegate> delegate;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *handleImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) float xPercentage;

+ (CGSize)size;
- (id)initWithFrame:(CGRect)frame;              // This class enforces a size appropriate for the control. The frame size is ignored.

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action
- (void)layoutForState;

- (void)loadBackground;
- (void)loadHandle;
- (void)loadLabel;
- (void)loadGestureRecognizers;

- (void)updateBackgroundImage;

@end
