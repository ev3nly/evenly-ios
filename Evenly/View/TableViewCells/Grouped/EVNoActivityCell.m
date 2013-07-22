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
#define LABEL_FONT [EVFont defaultFontOfSize:16]
#define SCREEN_WIDTH [UIApplication sharedApplication].keyWindow.bounds.size.width
#define LABEL_SIDE_BUFFER 20

@interface EVNoActivityCell ()

@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UILabel *noActivityLabel;

@end

@implementation EVNoActivityCell

+ (float)cellHeightForUser:(EVUser *)user {
    UILabel *label = [self configuredLabel];
    label.text = [user.dbid isEqualToString:[EVCIA me].dbid] ? [EVStringUtility noActivityMessageForSelf] : [EVStringUtility noActivityMessageForOthers];
    float labelHeight = [label.text sizeWithFont:label.font
                               constrainedToSize:CGSizeMake(SCREEN_WIDTH - LABEL_SIDE_BUFFER*2, 100000)
                                   lineBreakMode:label.lineBreakMode].height;
    return (TOP_BOTTOM_BUFFER + [EVImages inviteFriendsBanner].size.height + IMAGE_LABEL_BUFFER + labelHeight + TOP_BOTTOM_BUFFER);
}

+ (UILabel *)configuredLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = LABEL_FONT;
    label.numberOfLines = 0;
    return label;
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
    self.noActivityLabel = [[self class] configuredLabel];
    [self addSubview:self.noActivityLabel];
}

- (void)setUserIsSelf:(BOOL)userIsSelf {
    _userIsSelf = userIsSelf;
    
    self.noActivityLabel.text = userIsSelf ? [EVStringUtility noActivityMessageForSelf] : [EVStringUtility noActivityMessageForOthers];
}

- (CGRect)placeholderImageViewFrame {
    CGSize imageSize = [EVImages inviteFriendsBanner].size;
    return CGRectMake(CGRectGetMidX(self.bounds) - imageSize.width/2,
                      TOP_BOTTOM_BUFFER,
                      imageSize.width,
                      imageSize.height);
}

- (CGRect)noActivityLabelFrame {
    CGSize labelSize = [self.noActivityLabel.text sizeWithFont:self.noActivityLabel.font
                                             constrainedToSize:CGSizeMake(SCREEN_WIDTH - LABEL_SIDE_BUFFER*2, 100000)
                                                 lineBreakMode:self.noActivityLabel.lineBreakMode];
    return CGRectMake(CGRectGetMidX(self.bounds) - labelSize.width/2,
                      CGRectGetMaxY(self.placeholderImageView.frame) + IMAGE_LABEL_BUFFER,
                      labelSize.width,
                      labelSize.height);
}

@end
