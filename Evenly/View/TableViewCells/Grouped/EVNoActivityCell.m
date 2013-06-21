//
//  EVNoActivityCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNoActivityCell.h"

#define TOP_BOTTOM_BUFFER 30
#define IMAGE_LABEL_BUFFER 12
#define NO_ACTIVITY_TEXT @"No Activity Yet..."
#define LABEL_FONT [EVFont defaultFontOfSize:16]

@interface EVNoActivityCell ()

@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UILabel *noActivityLabel;

@end

@implementation EVNoActivityCell

+ (float)cellHeight {
    UILabel *label = [UILabel new];
    label.text = NO_ACTIVITY_TEXT;
    label.font = LABEL_FONT;
    [label sizeToFit];
    return (TOP_BOTTOM_BUFFER + [EVImages inviteFriendsBanner].size.height + IMAGE_LABEL_BUFFER + label.bounds.size.height + TOP_BOTTOM_BUFFER);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadPlaceholderImageView];
        [self loadNoActivityLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderImageView.frame = [self placeholderImageViewFrame];
    self.noActivityLabel.frame = [self noActivityLabelFrame];
}

- (void)loadPlaceholderImageView {
    self.placeholderImageView = [[UIImageView alloc] initWithImage:[EVImages inviteFriendsBanner]];
    [self addSubview:self.placeholderImageView];
}

- (void)loadNoActivityLabel {
    self.noActivityLabel = [UILabel new];
    self.noActivityLabel.backgroundColor = [UIColor clearColor];
    self.noActivityLabel.text = NO_ACTIVITY_TEXT;
    self.noActivityLabel.textAlignment = NSTextAlignmentCenter;
    self.noActivityLabel.textColor = [UIColor lightGrayColor];
    self.noActivityLabel.font = LABEL_FONT;
    [self addSubview:self.noActivityLabel];
}

- (CGRect)placeholderImageViewFrame {
    CGSize imageSize = [EVImages inviteFriendsBanner].size;
    return CGRectMake(CGRectGetMidX(self.bounds) - imageSize.width/2,
                      TOP_BOTTOM_BUFFER,
                      imageSize.width,
                      imageSize.height);
}

- (CGRect)noActivityLabelFrame {
    [self.noActivityLabel sizeToFit];
    return CGRectMake(CGRectGetMidX(self.bounds) - self.noActivityLabel.bounds.size.width/2,
                      CGRectGetMaxY(self.placeholderImageView.frame) + IMAGE_LABEL_BUFFER,
                      self.noActivityLabel.bounds.size.width,
                      self.noActivityLabel.bounds.size.height);
}

@end
