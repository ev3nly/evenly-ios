//
//  EVRequestInitialView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestWhoView.h"
#import "EVInstructionView.h"


#define REQUEST_SWITCH_HEIGHT 45
#define REQUEST_STRIPE_BUFFER 4


@interface EVRequestWhoView ()

@property (nonatomic, strong) UIView *requestSwitchBackground;

@end

@implementation EVRequestWhoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadRequestSwitch];
        [self setUpReactions];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"recipientCount"];
}

#pragma mark - View Loading

- (CGRect)upperStripeFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.requestSwitchBackground.frame) + REQUEST_STRIPE_BUFFER,
                      self.frame.size.width,
                      [EVUtilities scaledDividerHeight]);
}

- (void)loadRequestSwitch {
    self.requestSwitchBackground = [[UIView alloc] initWithFrame:[self requestSwitchBackgroundFrame]];
    self.requestSwitchBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:self.requestSwitchBackground];
    
    self.requestSwitch = [[EVRequestSwitch alloc] initWithFrame:[self requestSwitchFrame]];
    [self.requestSwitchBackground addSubview:self.requestSwitch];
    
    [self.upperStripe setFrame:[self upperStripeFrame]];
    [self.toField setFrame:[self toFieldFrame]];
    [self.lowerStripe setFrame:[self lowerStripeFrame]];
    
    [self.autocompleteTableView setFrame:[self tableViewFrame]];
}

- (CGRect)requestSwitchBackgroundFrame {
    return CGRectMake(0,
                      0,
                      self.frame.size.width,
                      REQUEST_SWITCH_HEIGHT);
}

- (CGRect)requestSwitchFrame {
    return CGRectMake(10, 7, 300, 35);
}

- (void)setUpReactions {
    [RACAble(self.requestSwitch.xPercentage) subscribeNext:^(NSNumber *percentage) {
        // TODO: Something with the flash message?
    }];
    
    // JH: I couldn't figure out a way to do this using ReactiveCocoa, so I just went back
    // to the old-fashioned KVO.  If anybody wants to get modern with this, please feel free.
    [self addObserver:self
           forKeyPath:@"recipientCount"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"recipientCount"])
    {
        int oldCount = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        int newCount = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        if (oldCount == 1 && newCount == 2 && ![self.requestSwitch isOn])
        {
            [self.requestSwitch setOn:YES animated:YES];
            self.didForceSwitchToGroup = YES;
        }
        else if (oldCount == 2 && newCount == 1 && self.didForceSwitchToGroup)
        {
            [self.requestSwitch setOn:NO animated:YES];
            self.didForceSwitchToGroup = NO;
        }
    }
}

- (void)layoutSubviews {
    [self.requestSwitchBackground setFrame:[self requestSwitchBackgroundFrame]];
    
    [self.upperStripe setFrame:[self upperStripeFrame]];
//    [self.toField setFrame:[self toFieldFrame]];
    [self.lowerStripe setFrame:[self lowerStripeFrame]];
    
    [self.autocompleteTableView setFrame:[self tableViewFrame]];
}

@end
