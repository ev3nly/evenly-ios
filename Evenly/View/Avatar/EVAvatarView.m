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
        
        self.overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AvatarContainer"]];
        [self.overlay setFrame:self.bounds];
        self.overlay.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self addSubview:self.overlay];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        CGSize avatarSize = [[self class] avatarSize];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, avatarSize.width, avatarSize.height) cornerRadius:4.0] CGPath];
        [shapeLayer setFillColor:[[UIColor blackColor] CGColor]];
        self.imageView.layer.mask = shapeLayer;
        

        
    }
    return self;
}

- (void)dealloc {
    [_avatarOwner removeObserver:self
                      forKeyPath:@"avatar"
                         context:&EVAvatarViewContext];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
