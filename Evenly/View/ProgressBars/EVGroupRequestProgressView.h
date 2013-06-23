//
//  EVGroupRequestProgressView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVProgressBar.h"

@interface EVGroupRequestProgressView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) EVProgressBar *progressBar;
@property (nonatomic) BOOL enabled;

+ (CGFloat)height;


@end
