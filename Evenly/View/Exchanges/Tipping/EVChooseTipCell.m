//
//  EVChooseTipCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVChooseTipCell.h"
#import "EVTip.h"

#define IMAGE_TITLE_BUFFER 0
#define TITLE_PRICE_BUFFER -1
#define LABEL_FONT_SIZE 13

@interface EVChooseTipCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation EVChooseTipCell

+ (CGSize)sizeForTipCell {
    return CGSizeMake(80, 100);
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadImageView];
        [self loadTitleLabel];
        [self loadPriceLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = [self imageViewFrame];
    self.titleLabel.frame = [self titleLabelFrame];
    self.priceLabel.frame = [self priceLabelFrame];
}

#pragma mark - View Loading

- (void)loadImageView {
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
}

- (void)loadTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [EVColor darkLabelColor];
    self.titleLabel.font = [EVFont boldFontOfSize:LABEL_FONT_SIZE];
    [self addSubview:self.titleLabel];
}

- (void)loadPriceLabel {
    self.priceLabel = [UILabel new];
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.textColor = [EVColor darkLabelColor];
    self.priceLabel.font = [EVFont defaultFontOfSize:LABEL_FONT_SIZE];
    [self addSubview:self.priceLabel];
}

#pragma mark - Setters

- (void)setTip:(EVTip *)tip {
    _tip = tip;
    
    self.imageView.image = tip.image;
    self.titleLabel.text = tip.title;
    self.priceLabel.text = [EVStringUtility amountStringForAmount:tip.amount];
}

#pragma mark - Frames

- (CGRect)imageViewFrame {
    return CGRectMake(0,
                      0,
                      self.bounds.size.width,
                      self.bounds.size.width);
}

- (CGRect)titleLabelFrame {
    [self.titleLabel sizeToFit];
    return CGRectMake(CGRectGetMidX(self.bounds) - self.titleLabel.bounds.size.width/2,
                      CGRectGetMaxY(self.imageView.frame) + IMAGE_TITLE_BUFFER,
                      self.titleLabel.bounds.size.width,
                      self.titleLabel.bounds.size.height);
}

- (CGRect)priceLabelFrame {
    [self.priceLabel sizeToFit];
    return CGRectMake(CGRectGetMidX(self.bounds) - self.priceLabel.bounds.size.width/2,
                      CGRectGetMaxY(self.titleLabel.frame) + TITLE_PRICE_BUFFER,
                      self.priceLabel.bounds.size.width,
                      self.priceLabel.bounds.size.height);
}

@end
