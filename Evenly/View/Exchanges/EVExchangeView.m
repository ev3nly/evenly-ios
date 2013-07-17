//
//  EVRequestView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeView.h"

#define TITLE_LABEL_X_MARGIN 10
#define TITLE_LABEL_HEIGHT 25
#define TITLE_LABEL_FONT [EVFont blackFontOfSize:16]

@implementation EVExchangeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadTitleLabel];
    }
    return self;
}

- (void)loadTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X_MARGIN,
                                                                EV_REQUEST_VIEW_LABEL_FIELD_BUFFER,
                                                                self.frame.size.width - 2*TITLE_LABEL_X_MARGIN,
                                                                TITLE_LABEL_HEIGHT)];
    self.titleLabel.font = TITLE_LABEL_FONT;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.adjustsLetterSpacingToFitWidth = YES;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.6;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.titleLabel];
}

- (void)flashMessage:(NSString *)message inFrame:(CGRect)frame withDuration:(NSTimeInterval)duration {
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(view.bounds, 5, 2)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [EVColor lightRedColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [EVFont defaultFontOfSize:15];
    label.text = message;
    label.alpha = 1.0f;
    [view addSubview:label];
    [self addSubview:view];
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                     animations:^{
                         view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                                               delay:duration
                                             options:0
                                          animations:^{
                                              view.alpha = 0.0f;
                                          } completion:^(BOOL finished) {
                                              [view removeFromSuperview];
                                          }];
                     }];
}

@end
