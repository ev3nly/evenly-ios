//
//  EVRewardsCardAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsCardAmountView.h"

@interface EVRewardsCardAmountView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation EVRewardsCardAmountView

+ (instancetype)cardWithColor:(EVRewardsSliderColor)color {
    return [self cardWithColor:color text:nil];
}

+ (instancetype)cardWithColor:(EVRewardsSliderColor)color text:(NSString *)text {
    EVRewardsCardAmountView *view = [[EVRewardsCardAmountView alloc] initWithColor:color];
    [view setText:text];
    return view;
}

+ (instancetype)greenCardWithText:(NSString *)text {
    return [self cardWithColor:EVRewardsSliderColorGreen text:text];
}

+ (instancetype)grayCardWithText:(NSString *)text {
    return [self cardWithColor:EVRewardsSliderColorGray text:text];
}

+ (instancetype)blueCardWithText:(NSString *)text {
    return [self cardWithColor:EVRewardsSliderColorBlue text:text];
}

- (id)initWithColor:(EVRewardsSliderColor)color {
    self = [self initWithFrame:CGRectMake(0, 0, EV_REWARDS_CARD_AMOUNT_VIEW_WIDTH, EV_REWARDS_CARD_AMOUNT_VIEW_HEIGHT)];
    if (self) {
        self.cardColor = color;
        
        self.imageView = [[UIImageView alloc] initWithImage:[self imageForColor:self.cardColor]];
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0, self.frame.size.width, 25.0)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [EVFont boldFontOfSize:24.0];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = (self.cardColor == EVRewardsSliderColorGray ? [EVColor darkColor] : [UIColor whiteColor]);
        [self addSubview:self.label];
    }
    return self;
}

- (void)setCardColor:(EVRewardsSliderColor)cardColor {
    _cardColor = cardColor;
    [self.imageView setImage:[self imageForColor:self.cardColor]];
    self.label.textColor = (self.cardColor == EVRewardsSliderColorGray ? [EVColor darkColor] : [UIColor whiteColor]);

}

- (UIImage *)imageForColor:(EVRewardsSliderColor)color {
    UIImage *image = nil;
    switch (color) {
        case EVRewardsSliderColorGreen:
            image = [EVImages rewardsGreenCardImage];
            break;
        case EVRewardsSliderColorGray:
            image = [EVImages rewardsGrayCardImage];
            break;
        case EVRewardsSliderColorBlue:
            image = [EVImages rewardsBlueCardImage];
            break;
        default:
            break;
    }
    return image;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
