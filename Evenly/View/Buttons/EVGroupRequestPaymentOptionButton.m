//
//  EVGroupRequestPaymentOptionButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPaymentOptionButton.h"
#import "EVGroupRequestTier.h"

#define DEFAULT_WIDTH 275.0
#define DEFAULT_HEIGHT 30.0
#define HORIZONTAL_MARGIN 10.0

@implementation EVGroupRequestPaymentOptionButton

+ (instancetype)buttonForTier:(EVGroupRequestTier *)tier {
    return [[self alloc] initWithTier:tier];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checkboxImageView = [[UIImageView alloc] initWithImage:[self normalImage]];
        [self addSubview:self.checkboxImageView];
        self.checked = NO;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor lightLabelColor];
        self.label.font = [EVFont defaultFontOfSize:15];
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.numberOfLines = 0;
        [self addSubview:self.label];
    }
    return self;
}

- (id)initWithTier:(EVGroupRequestTier *)tier {
    CGSize size = [self sizeForText:[tier optionString]];
    self = [self initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH, size.height)];
    if (self) {
        [self.label setText:[tier optionString]];
        [self setNeedsLayout];
    }
    return self;
}

- (UIImage *)normalImage {
    return [UIImage imageNamed:@"check-hole"];
}

- (UIImage *)selectedImage {
    return [UIImage imageNamed:@"checked"];
}

- (CGSize)sizeForText:(NSString *)text {
    CGSize size = [text boundingRectWithSize:CGSizeMake(DEFAULT_WIDTH - [self normalImage].size.width - HORIZONTAL_MARGIN, FLT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: [EVFont defaultFontOfSize:15]}
                                     context:NULL].size;
    size.height = MAX(size.height, [self normalImage].size.height);
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.checkboxImageView.frame = CGRectMake(0, 0, self.checkboxImageView.frame.size.width, self.checkboxImageView.frame.size.height);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.checkboxImageView.frame) + HORIZONTAL_MARGIN,
                                  0,
                                  self.frame.size.width - self.checkboxImageView.frame.size.width - 2*HORIZONTAL_MARGIN,
                                  self.frame.size.height);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self fadeBetweenChecks];
}

- (BOOL)isSelected {
    return self.isChecked;
}

- (void)fadeBetweenChecks {
    UIImage *newCheckImage = !self.isChecked ? [EVImages checkHoleChecked] : [EVImages checkHoleEmpty];
    UIImageView *newCheck = [[UIImageView alloc] initWithImage:newCheckImage];
    newCheck.frame = self.checkboxImageView.frame;
    newCheck.alpha = self.isChecked;
    [self addSubview:newCheck];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.isChecked)
                             self.checkboxImageView.alpha = 0;
                         else
                             newCheck.alpha = 1;
                     } completion:^(BOOL finished) {
                         self.checkboxImageView.alpha = 1;
                         self.checked = !self.isChecked;
                         [newCheck removeFromSuperview];
                     }];
}

#pragma mark - Setters

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    
    if (checked)
        self.checkboxImageView.image = [EVImages checkHoleChecked];
    else
        self.checkboxImageView.image = [EVImages checkHoleEmpty];
}

@end
