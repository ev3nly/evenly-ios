//
//  EVInstructionView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVInstructionView : UIView

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic) BOOL showingLogo;

- (id)initWithText:(NSString *)text;
- (id)initWithAttributedText:(NSAttributedString *)attributedText;

- (void)showInView:(UIView *)view;
- (void)flashInView:(UIView *)view forDuration:(NSTimeInterval)duration;

- (void)dismiss;

@end
