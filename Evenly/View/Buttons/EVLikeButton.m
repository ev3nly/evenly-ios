//
//  EVLikeButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVLikeButton.h"

@interface EVLikeButton ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *label;

@end

@implementation EVLikeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.spacing = 5.0f;
        
        self.container = [[UIView alloc] initWithFrame:CGRectZero];
        self.container.userInteractionEnabled = NO;
        
        self.likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Heart"]];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [EVFont boldFontOfSize:14];
        self.label.textColor = [EVColor newsfeedButtonLabelColor];
        self.label.backgroundColor = [UIColor clearColor];
        
        [self.container addSubview:self.likeIcon];
        [self.container addSubview:self.label];
        self.container.backgroundColor = [UIColor clearColor];
        [self.container sizeToFit];
        [self addSubview:self.container];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.label setText:_title];
    [self setNeedsLayout];
}

- (void)layoutSubviews {

    [self.label sizeToFit];

    [self.container setSize:CGSizeMake(self.likeIcon.frame.size.width + self.spacing + self.label.frame.size.width, MAX(self.likeIcon.frame.size.height, self.label.frame.size.height))];
    self.container.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.container.frame = CGRectIntegral(self.container.frame);
    
    self.likeIcon.frame = CGRectMake(0, (self.container.frame.size.height - self.likeIcon.frame.size.height) / 2.0,
                                     self.likeIcon.frame.size.width, self.likeIcon.frame.size.height);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.likeIcon.frame) + self.spacing,
                                  (self.container.frame.size.height - self.label.frame.size.height) / 2.0,
                                  self.label.frame.size.width,
                                  self.label.frame.size.height);

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected)
        self.likeIcon.image = [UIImage imageNamed:@"HeartRed"];
    else
        self.likeIcon.image = [UIImage imageNamed:@"Heart"];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setBackgroundColor:(highlighted ? [EVColor newsfeedButtonHighlightColor] : [UIColor clearColor])];
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
