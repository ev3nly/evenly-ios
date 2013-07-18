//
//  EVRequestView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EV_REQUEST_VIEW_LABEL_FIELD_BUFFER 10

@interface EVExchangeView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

- (void)flashMessage:(NSString *)message inFrame:(CGRect)frame withDuration:(NSTimeInterval)duration;

@end
