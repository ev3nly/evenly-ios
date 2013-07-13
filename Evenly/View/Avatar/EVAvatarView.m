//
//  EVAvatarView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAvatarView.h"
#import <QuartzCore/QuartzCore.h>

static void *EVAvatarViewContext = &EVAvatarViewContext;

@interface EVAvatarView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *overlay;

@end

@implementation EVAvatarView

+ (CGSize)avatarSize { return CGSizeMake(44.0, 44.0);  }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.cornerRadius = 4.0;
        
        self.overlay = [[UIImageView alloc] initWithFrame:self.bounds];
        self.overlay.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.overlay.contentMode = UIViewContentModeScaleAspectFit;
        [self.overlay setImage:[EVImages defaultAvatar]];
        [self addSubview:self.overlay];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.size = frame.size;
    }
    return self;
}

- (void)dealloc {
    [_avatarOwner removeObserver:self
                      forKeyPath:@"avatar"
                         context:&EVAvatarViewContext];
}

- (void)configureMasks {
    CGSize avatarSize = self.size;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, avatarSize.width, avatarSize.height) cornerRadius:self.cornerRadius] CGPath];
    [shapeLayer setFillColor:[[UIColor blackColor] CGColor]];
    self.imageView.layer.mask = shapeLayer;
    
    CAShapeLayer *overlayLayer = [CAShapeLayer layer];
    overlayLayer.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, avatarSize.width, avatarSize.height) cornerRadius:self.cornerRadius] CGPath];
    [overlayLayer setFillColor:[[UIColor blackColor] CGColor]];
    self.overlay.layer.mask = overlayLayer;
}

- (void)setAvatarOwner:(id<EVAvatarOwning>)avatarOwner {
    [_avatarOwner removeObserver:self
                      forKeyPath:@"avatar"
                         context:&EVAvatarViewContext];
    _avatarOwner = avatarOwner;
    self.imageView.image = _avatarOwner.avatar;
    [_avatarOwner addObserver:self
                   forKeyPath:@"avatar"
                      options:NSKeyValueObservingOptionNew
                      context:&EVAvatarViewContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context != &EVAvatarViewContext) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    self.imageView.image = _avatarOwner.avatar;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setSize:frame.size];
}

- (void)setSize:(CGSize)size {
    _size = size;
    [self configureMasks];
}

- (void)setCornerRadius:(float)cornerRadius {
    _cornerRadius = cornerRadius;
    [self configureMasks];
}

@end
