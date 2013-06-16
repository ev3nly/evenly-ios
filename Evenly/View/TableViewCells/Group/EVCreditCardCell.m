//
//  EVCreditCardCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCreditCardCell.h"

@interface EVCreditCardCell ()

- (void)setUpBrandImage:(UIImage *)brandImage;
- (void)setUpLastFour:(NSString *)lastFour;

@end

@implementation EVCreditCardCell

- (id)initWithLastFour:(NSString *)lastFour andBrandImage:(UIImage *)brandImage {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CreditCardCell"];
    if (self) {
        [self setUpBrandImage:brandImage];
        [self setUpLastFour:lastFour];
    }
    return self;
}

- (void)setUpBrandImage:(UIImage *)brandImage {
    self.imageView.image = brandImage;
    if (self.imageView.image == nil)
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)setUpLastFour:(NSString *)lastFour {
    self.textLabel.text = [NSString stringWithFormat:@"**** **** **** %@", lastFour];
    self.textLabel.textColor = [EVColor newsfeedTextColor];
    self.textLabel.font = [UIFont systemFontOfSize:16];
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
