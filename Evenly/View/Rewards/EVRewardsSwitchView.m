//
//  EVRewardsSwitchView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsSwitchView.h"

#define X_MARGIN 20

@implementation EVRewardsSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [EVColor lightColor];
        
        [self loadLabel];
        [self loadSwitch];
    }
    return self;
}

- (void)loadLabel {

    CGFloat labelWidth = 190;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, labelWidth, self.frame.size.height)];
    self.label.numberOfLines = 2;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [EVColor darkColor];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSDictionary *normalAttributes = @{ NSFontAttributeName : [EVFont defaultFontOfSize:12],
                                        NSForegroundColorAttributeName : [EVColor darkColor] };
    NSDictionary *boldAttributes = @{ NSFontAttributeName : [EVFont blackFontOfSize:12],
                                      NSForegroundColorAttributeName : [EVColor darkColor] };
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Share your reward on Facebook and "
                                                                       attributes:normalAttributes]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"increase your mojo"
                                                                       attributes:boldAttributes]];
    
    self.label.attributedText = attrString;
    
    [self addSubview:self.label];
}

- (void)loadSwitch {
    self.shareSwitch = [[EVSwitch alloc] initWithFrame:CGRectZero];
    CGPoint origin = CGPointMake(self.frame.size.width - X_MARGIN - self.shareSwitch.frame.size.width,
                                 (self.frame.size.height - self.shareSwitch.frame.size.height) / 2.0);
    [self.shareSwitch setOrigin:origin];
    
    [self addSubview:self.shareSwitch];
    [self.shareSwitch setOn:YES animated:NO];
}

@end
