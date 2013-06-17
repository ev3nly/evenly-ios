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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [EVFont boldFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.textLabel.text = nil;
}

- (void)setUpWithLastFour:(NSString *)lastFour andBrandImage:(UIImage *)brandImage {
    [self setUpLastFour:lastFour];
    [self setUpBrandImage:brandImage];
}

- (void)setUpBrandImage:(UIImage *)brandImage {
    self.imageView.image = brandImage;
    if (self.imageView.image == nil)
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)setUpLastFour:(NSString *)lastFour {
    self.textLabel.text = [NSString stringWithFormat:@"**** **** **** %@", lastFour];
    self.textLabel.textColor = [EVColor newsfeedTextColor];
    self.textLabel.font = [EVFont defaultFontOfSize:16];
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
