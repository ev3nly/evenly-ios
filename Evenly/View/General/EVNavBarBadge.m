//
//  EVNavBarBadge.m
//  Evenly
//
//  Created by Justin Brunet on 7/22/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavBarBadge.h"

#define LABEL_OFFSET 0.5
#define LABEL_SIDE_BUFFER 4

@interface EVNavBarBadge ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation EVNavBarBadge

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBackgroundView];
        [self loadNumberLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = [self backgroundViewFrame];
    self.numberLabel.frame = [self numberLabelFrame];
}

- (CGSize)sizeThatFits:(CGSize)size {
//    float labelWidth = [self.numberLabel.text sizeWithFont:self.numberLabel.font
//                                         constrainedToSize:CGSizeMake(320, 1000000)
//                                             lineBreakMode:self.numberLabel.lineBreakMode].width;
    return CGSizeMake(fmaxf(0/*labelWidth + LABEL_SIDE_BUFFER*2*/, self.backgroundView.image.size.width), self.backgroundView.image.size.height);
}

#pragma mark - View Loading

- (void)loadBackgroundView {
    self.backgroundView = [[UIImageView alloc] initWithImage:[EVImages navBarNotificationBackground]];
    [self addSubview:self.backgroundView];
}

- (void)loadNumberLabel {
    self.numberLabel = [UILabel new];
    self.numberLabel.backgroundColor = [UIColor clearColor];
    self.numberLabel.font = [EVFont boldFontOfSize:12];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [EVColor lightColor];
    self.numberLabel.text = @""; 
    [self addSubview:self.numberLabel];
}

#pragma mark - Setters

- (void)setNumber:(int)number {
    _number = number;
    
    self.numberLabel.text = EV_STRING_FROM_INT(number);
}

- (void)setShouldFlag:(BOOL)shouldFlag {
    _shouldFlag = shouldFlag;
    
    self.backgroundView.image = shouldFlag ? [EVImages navBarNotificationBackgroundRed] : [EVImages navBarNotificationBackground];
}

#pragma mark - Frames

- (CGRect)backgroundViewFrame {
    return self.bounds;
}

- (CGRect)numberLabelFrame {
    CGRect numberFrame = self.bounds;
    numberFrame.origin.x += LABEL_OFFSET;
    numberFrame.origin.y += LABEL_OFFSET;
    return numberFrame;
}

@end
