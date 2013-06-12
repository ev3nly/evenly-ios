//
//  EVNetworkSelectorCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNetworkSelectorCell.h"
#import "EVImages.h"

#define LABEL_X_ORIGIN 40
#define LABEL_RIGHT_BUFFER 10

@interface EVNetworkSelectorCell () {
    UIImageView *_imageView;
    UILabel *_label;
}

- (void)loadImageView;
- (void)loadLabel;

- (UIImage *)imageForType:(EVNetworkSelectorCellType)type;
- (NSString *)textForType:(EVNetworkSelectorCellType)type;

- (CGRect)imageViewFrame;
- (CGRect)labelFrame;

@end

@implementation EVNetworkSelectorCell

- (id)initWithFrame:(CGRect)frame andType:(EVNetworkSelectorCellType)type
{
    if (self = [super initWithFrame:frame])
    {
        _type = type;
        [self loadImageView];
        [self loadLabel];
    }
    return self;
}

- (void)loadImageView
{
    _imageView = [[UIImageView alloc] initWithImage:[self imageForType:self.type]];
    _imageView.frame = [self imageViewFrame];
    [self addSubview:_imageView];
}

- (void)loadLabel
{
    _label = [UILabel new];
    _label.text = [self textForType:self.type];
    _label.textColor = EV_RGB_COLOR(50, 50, 50);
    _label.font = [EVFont boldFontOfSize:14];
    _label.frame = [self labelFrame];
    [self addSubview:_label];
}

- (UIImage *)imageForType:(EVNetworkSelectorCellType)type {
    switch (type) {
        case EVNetworkSelectorCellTypeCurrentSelection:
            return [EVImages lockIcon];
        case EVNetworkSelectorCellTypeFriends:
            return [EVImages friendsIcon];
        case EVNetworkSelectorCellTypeNetwork:
            return [EVImages globeIcon];
        case EVNetworkSelectorCellTypePrivate:
            return [EVImages lockIcon];
        default:
            return nil;
    }
}

- (NSString *)textForType:(EVNetworkSelectorCellType)type {
    switch (type) {
        case EVNetworkSelectorCellTypeCurrentSelection:
            return @"CURRENT";
        case EVNetworkSelectorCellTypeFriends:
            return @"Friends";
        case EVNetworkSelectorCellTypeNetwork:
            return @"Network";
        case EVNetworkSelectorCellTypePrivate:
            return @"Private";
        default:
            return nil;
    }
}

- (CGRect)imageViewFrame {
    return CGRectMake(LABEL_X_ORIGIN/2 - _imageView.image.size.width/2,
                      self.bounds.size.height/2 - _imageView.image.size.height/2,
                      _imageView.image.size.width,
                      _imageView.image.size.height);
}

- (CGRect)labelFrame {
    return CGRectMake(LABEL_X_ORIGIN,
                      0,
                      self.bounds.size.width - LABEL_X_ORIGIN - LABEL_RIGHT_BUFFER,
                      self.bounds.size.height);
}

@end
