//
//  EVRewardsSliderBackground.m
//  Evenly
//
//  Created by Joseph Hankin on 7/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsSliderBackground.h"
#import "NSArray+EVAdditions.h"
#import "EVRewardsCardAmountView.h"

#define NUMBER_OF_LOGOS 6

@interface EVRewardsSliderBackground ()

@property (nonatomic) BOOL animating;
@property (nonatomic) int currentLogoIndex;
@property (nonatomic) BOOL increasing;
@property (nonatomic, strong) NSArray *indices;
@end

@implementation EVRewardsSliderBackground

- (id)initWithFrame:(CGRect)frame sliderColor:(EVRewardsSliderColor)color {
    self = [self initWithFrame:frame];
    if (self) {
        NSMutableArray *array = [NSMutableArray array];
        CGRect frame = (CGRect){CGPointZero, [self logoSize]};
        for (int i = 0; i < NUMBER_OF_LOGOS; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView setImage:[self whiteLogo]];
            [self addSubview:imageView];
            [array addObject:imageView];
        }
        self.logos = [NSArray arrayWithArray:array];
        self.animating = NO;
        
        self.rewardCard = [EVRewardsCardAmountView cardWithColor:color];
        [self.rewardCard setCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)];
    }
    return self;
}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount {
    [self setRewardAmount:rewardAmount animated:NO];
}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated {
    _rewardAmount = rewardAmount;
    [self.rewardCard setText:[EVStringUtility amountStringForAmount:_rewardAmount]];

    if (!animated) {
        [self.rewardCard setCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)];
        [self addSubview:self.rewardCard];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.logos makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        [self.rewardCard setCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)];
        [self.rewardCard setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
        [self addSubview:self.rewardCard];
        [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                         animations:^{
                             [self setBackgroundColor:[UIColor whiteColor]];
                             [self stopAnimating];
                         } completion:^(BOOL finished) {
                             [self.logos makeObjectsPerformSelector:@selector(removeFromSuperview)];
                             [UIView animateWithDuration:1.0f
                                              animations:^{
                                                  [self.rewardCard setTransform:CGAffineTransformIdentity];
                                                  for (UIImageView *logo in self.logos) {
                                                      [logo setAlpha:0.0f];
                                                  }
                                              } completion:^(BOOL finished){
                                                  
                                              }];
                         }];
    }
}

#pragma mark - Images

- (CGSize)logoSize {
    return CGSizeMake(22, 22);
}

- (UIImage *)whiteLogo {
    return [UIImage imageNamed:@"popover_logo"];
}

- (UIImage *)coloredLogo {
    return [UIImage imageNamed:@"small_logo"];
}

#pragma mark - Animation

- (void)startAnimating {
    self.animating = YES;
    [self performAnimation];
}

- (void)performAnimation {
    if (!self.animating)
        return;
    
    if (!self.indices)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<NUMBER_OF_LOGOS; i++)
        {
            [array addObject:@(i)];
        }
        [array shuffle];
        self.indices = (NSArray *)array;
    }
    
    [[self currentImageView] setImage:[self coloredLogo]];
    [[self previousImageView] setImage:[self whiteLogo]];
    
    [self adjustLogoIndex];

    EV_DISPATCH_AFTER(0.08, ^{
        EV_PERFORM_ON_MAIN_QUEUE(^{
            [self performAnimation];
        });
    });
}

- (UIImageView *)currentImageView {
    return [self.logos objectAtIndex:[[_indices objectAtIndex:_currentLogoIndex] intValue]];
}

- (UIImageView *)previousImageView {
    if (_currentLogoIndex == 0 && _increasing)
        return nil;
    if (_currentLogoIndex == (self.logos.count - 1) && !_increasing)
        return nil;
    
    int index;
    if (_increasing)
        index = _currentLogoIndex-1;
    else
        index = _currentLogoIndex+1;
    return [self.logos objectAtIndex:[[_indices objectAtIndex:index] intValue]];
}

- (void)adjustLogoIndex {
    if (_increasing) {
        _currentLogoIndex++;
        if (_currentLogoIndex == self.logos.count) {
            _currentLogoIndex -= 2;
            _increasing = NO;
        }
    } else {
        _currentLogoIndex--;
        if (_currentLogoIndex == -1) {
            _currentLogoIndex += 2;
            _increasing = YES;
        }
    }
}

- (void)stopAnimating {
    self.animating = NO;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = (self.frame.size.width - ([self logoSize].width * self.logos.count)) / (self.logos.count + 1);
    int i = 0;
    for (UIImageView *imageView in self.logos) {
        [imageView setFrame:CGRectMake((i+1)*spacing + i*[self logoSize].width,
                                       (self.frame.size.height - imageView.frame.size.height) / 2.0,
                                       imageView.frame.size.width,
                                       imageView.frame.size.height)];
        i++;
    }
}

@end
