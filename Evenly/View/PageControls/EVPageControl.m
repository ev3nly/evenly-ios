//
//  EVPageControl.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPageControl.h"

#define EV_PAGE_CONTROL_DOT_WIDTH 5.0
#define EV_PAGE_CONTROL_DOT_HEIGHT 6.0

@interface EVPageControl () 

@property (nonatomic, strong) NSMutableArray *pageIndicators;

@end

@implementation EVPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageIndicators = [NSMutableArray array];
        self.currentPage = 0;
        self.xSpacing = 5.0f;
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self reloadSubviews];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self reloadSubviews];
}

- (UIImage *)dotImage {
    return [UIImage imageNamed:@"Request-header-dot"];
}

- (UIImage *)holeImage {
    return [UIImage imageNamed:@"Request-header-hole"];
}

- (void)reloadSubviews {
    [self.pageIndicators makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pageIndicators removeAllObjects];
    
    for (int i = 0; i < self.numberOfPages; i++) {
        UIImage *image = (i == self.currentPage ? [self dotImage] : [self holeImage]);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.pageIndicators addObject:imageView];
    }
    
    if ([self.pageIndicators count] == 0)
        return;
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([self.pageIndicators count] * EV_PAGE_CONTROL_DOT_WIDTH, EV_PAGE_CONTROL_DOT_HEIGHT);
}

- (void)layoutSubviews {
    CGFloat step = self.xSpacing;
    
    CGSize totalSize = CGSizeMake(self.numberOfPages * EV_PAGE_CONTROL_DOT_WIDTH + ((_numberOfPages - 1) * step),
                                  EV_PAGE_CONTROL_DOT_HEIGHT);
    
    
    CGPoint origin = CGPointMake((self.frame.size.width - totalSize.width) / 2.0,
                                 (self.frame.size.height - totalSize.height) / 2.0);
    for (UIImageView *imageView in _pageIndicators) {
        CGRect frame = imageView.frame;
        frame.origin = origin;
        imageView.frame = frame;
        [self addSubview:imageView];
        
        origin.x += EV_PAGE_CONTROL_DOT_WIDTH + step;
    }
}

@end
