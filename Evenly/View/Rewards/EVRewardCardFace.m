//
//  EVRewardCardFace.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardCardFace.h"

#define LOGO_PADDING 10.0
#define LABEL_MARGIN 5.0
#define AMOUNT_LABEL_Y_MARGIN 2.0

@interface EVRewardCardFace ()

@property (nonatomic) BOOL animating;

- (void)loadLogo;
- (void)loadStripes;
- (void)loadAmountLabel;
- (void)loadMessageLabel;

@end

@implementation EVRewardCardFace

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
        
        self.throbber = [[EVThrobber alloc] initWithThrobberStyle:EVThrobberStyleLight];
        self.throbber.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        [self addSubview:self.throbber];
        
        self.contentContainer = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentContainer];
        self.contentContainer.alpha = 0.0;
        
        [self loadLogo];
        [self loadStripes];
        [self loadAmountLabel];
        [self loadMessageLabel];
        
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void)loadLogo {
    self.logo = [[UIImageView alloc] initWithImage:[EVImages rewardCardLogo]];
    self.logo.center = CGPointMake(self.contentContainer.bounds.size.width / 2.0, self.contentContainer.bounds.size.height / 2.0);
    [self.contentContainer addSubview:self.logo];
}

- (void)loadStripes {
    CGRect frame;
    UIView *stripe;
    
    frame = CGRectMake(0, self.frame.size.height / 2.0, CGRectGetMinX(self.logo.frame) - LOGO_PADDING, 1);
    stripe = [[UIView alloc] initWithFrame:frame];
    stripe.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.43];
    [self.contentContainer addSubview:stripe];
    self.leftStripe = stripe;
    
    frame = CGRectMake(CGRectGetMaxX(self.logo.frame) + LOGO_PADDING,
                       self.frame.size.height / 2.0,
                       self.frame.size.width - LOGO_PADDING - CGRectGetMaxX(self.logo.frame),
                       1);
    stripe = [[UIView alloc] initWithFrame:frame];
    stripe.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.43];
    [self.contentContainer addSubview:stripe];
    self.rightStripe = stripe;
}

- (void)loadAmountLabel {
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AMOUNT_LABEL_Y_MARGIN, self.frame.size.width, CGRectGetMinY(self.logo.frame) - LOGO_PADDING)];
    self.amountLabel.font = [EVFont blackFontOfSize:16];
    self.amountLabel.backgroundColor = [UIColor clearColor];
    self.amountLabel.textColor = [UIColor whiteColor];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self.contentContainer addSubview:self.amountLabel];
}

- (void)loadMessageLabel {
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN,
                                                                  CGRectGetMaxY(self.logo.frame) + LOGO_PADDING,
                                                                  self.frame.size.width - 2*LABEL_MARGIN,
                                                                  self.frame.size.height - LOGO_PADDING - CGRectGetMaxY(self.logo.frame))];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.font = [EVFont bookFontOfSize:12];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT | UIViewAutoresizingFlexibleTopMargin;
    self.messageLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentContainer addSubview:self.messageLabel];
}

- (void)startAnimating {
    self.animating = YES;
    [self.throbber startAnimating];
}

- (void)stopAnimating {
    self.animating = NO;
    [self.throbber stopAnimating];
}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated completion:(void (^)(void))completion {
    _rewardAmount = rewardAmount;
    NSString *amountString = [EVStringUtility amountStringForAmount:_rewardAmount];
    [self.amountLabel setText:amountString];
    NSString *messageText = nil;
    if (animated)
    {
        if ([rewardAmount isEqual:[NSDecimalNumber zero]]) {
            messageText = @"So close! Better luck next time.";
        } else {
            messageText = [NSString stringWithFormat:@"Nice! You've won %@", amountString];
        }
    }
    else
    {
        messageText = @"Thanks for playing!";
    }
    self.messageLabel.text = messageText;
    
    [self stopAnimating];
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0)
                     animations:^{
                         self.contentContainer.alpha = 1.0;
                    
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                             completion();
                     }
     ];
}

@end
