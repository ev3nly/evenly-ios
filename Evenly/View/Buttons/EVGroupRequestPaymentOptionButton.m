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
    CGSize size = [text sizeWithFont:[EVFont defaultFontOfSize:15] constrainedToSize:CGSizeMake(DEFAULT_WIDTH - [self normalImage].size.width - HORIZONTAL_MARGIN, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
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
    self.checkboxImageView.image = (selected ? [self selectedImage] : [self normalImage]);
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
