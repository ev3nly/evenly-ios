//
//  EVPagingScrollView.m
//  TCTouch
//
//  Created by Joseph Hankin on 1/27/12.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPagingScrollView.h"
#import "EVPageView.h"

@implementation EVPagingScrollView

@synthesize dataSource = _dataSource;
@synthesize pagingDelegate = _pagingDelegate;
@synthesize pageSize = _pageSize;
@synthesize lookAhead = _lookAhead;
@synthesize lookBehind = _lookBehind;

#pragma mark - Creation and Destruction

- (id)initWithFrame:(CGRect)frame direction:(EVPagingScrollViewDirection)direction {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        
        _visiblePageSet = [[NSMutableSet alloc] init];
        _reusablePageSet = [[NSMutableSet alloc] init];
        
        _pageSize = CGSizeMake(-1, -1);
        _pageCount = 0;
        _direction = direction;
    }
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view { 
    return YES;
}

#pragma mark - Dimensions

- (void)setFrame:(CGRect)frame {
    NSInteger currentIndex = [self currentPageIndex];
    CGSize newPageSize = _pageSize;
    if (_pageSize.width < 0 || _pageSize.height < 0)
        newPageSize = frame.size;
    self.contentSize = ((_direction == EVPagingScrollViewDirectionHorizontal) ? 
                        CGSizeMake(newPageSize.width * _pageCount, newPageSize.height) : 
                        CGSizeMake(newPageSize.width, newPageSize.height * _pageCount));
    for (EVPageView *pageView in _visiblePageSet) {
        pageView.frame = ((_direction == EVPagingScrollViewDirectionHorizontal) ?
                          CGRectMake(newPageSize.width * pageView.pageNumber, 0, newPageSize.width, frame.size.height) : 
                          CGRectMake(0, newPageSize.height * pageView.pageNumber, frame.size.width, newPageSize.height));
    }
    self.contentOffset = ((_direction == EVPagingScrollViewDirectionHorizontal) ? 
                          CGPointMake(newPageSize.width * currentIndex, 0) : 
                          CGPointMake(0, newPageSize.height * currentIndex));
    [super setFrame:frame];
}

#pragma mark - Data

- (void)setDataSource:(NSObject<EVPagingScrollViewDataSource> *)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData {
    if (!self.dataSource)
        return;
    
    CGSize size = _pageSize;
    if (_pageSize.width < 0 || _pageSize.height < 0)
        size = self.bounds.size;
    
    _pageCount = [self.dataSource numberOfPagesInPagingScrollView:self];
    self.contentSize = ((_direction == EVPagingScrollViewDirectionHorizontal) ? 
                        CGSizeMake(size.width * _pageCount, size.height) : 
                        CGSizeMake(size.width, size.height * _pageCount));
    
    [_reusablePageSet unionSet:_visiblePageSet];
    [_visiblePageSet removeAllObjects];
    for (UIView *tmpView in [self subviews])
        [tmpView removeFromSuperview];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if (self.pagingDelegate && [self.pagingDelegate respondsToSelector:@selector(pagingScrollView:didStopAtPage:)])
        [self.pagingDelegate pagingScrollView:self didStopAtPage:[self currentPageIndex]];
}

#pragma mark - Reusable Views

- (EVPageView *)dequeueReusableViewWithIdentifier:(NSString *)identifier {
    EVPageView *pageView = nil;
    for (pageView in _reusablePageSet) {
        if ([pageView.reuseIdentifier isEqualToString:identifier])
            break;
    }
    if (!pageView)
        return nil;
    
    [_reusablePageSet removeObject:pageView];
    [pageView prepareForReuse];
    return pageView;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.dataSource)
        return;
    
    // This logic is borrowed from the WWDC PhotoScroller example project
	CGSize tmpSize = (_pageSize.width < 0 ? self.bounds.size : _pageSize);
    
    // Calculate which pages are visible
    CGRect visibleBounds = self.bounds;
    int firstNeededPageIndex = (_direction == EVPagingScrollViewDirectionHorizontal ? floorf(CGRectGetMinX(visibleBounds) / tmpSize.width) : floorf(CGRectGetMinY(visibleBounds) / tmpSize.height));
    int lastNeededPageIndex  = (_direction == EVPagingScrollViewDirectionHorizontal ? floorf((CGRectGetMaxX(visibleBounds)-1) / tmpSize.width) : floorf((CGRectGetMaxY(visibleBounds)-1) / tmpSize.height));
    firstNeededPageIndex = MAX(firstNeededPageIndex - (int)_lookBehind, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex + (int)_lookAhead, _pageCount - 1);
    

    EVPageView *pageView = nil;
	for (pageView in _visiblePageSet)
	{
		if (pageView.pageNumber < firstNeededPageIndex || pageView.pageNumber > lastNeededPageIndex)
		{
			[_reusablePageSet addObject:pageView];
			[pageView removeFromSuperview];
		}
	}
	[_visiblePageSet minusSet:_reusablePageSet];
    
	for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; i++)
	{
		BOOL tmpPageFound = NO;
		for (pageView in _visiblePageSet)
		{
			if (pageView.pageNumber == i)
			{
				tmpPageFound = YES;
                [pageView setFrame:((_direction == EVPagingScrollViewDirectionHorizontal) ?
                                    CGRectMake(i*tmpSize.width, 0, tmpSize.width, self.bounds.size.height) :
                                    CGRectMake(0, i*tmpSize.height, self.bounds.size.width, tmpSize.height))];
				break;
			}
		}
        
		if (!tmpPageFound)
		{
			pageView = [self.dataSource pagingScrollView:self pageViewForIndex:i];
			if (pageView)
			{
                pageView.pageNumber = i;
                [pageView setFrame:((_direction == EVPagingScrollViewDirectionHorizontal) ?
                                    CGRectMake(i*tmpSize.width, 0, tmpSize.width, self.bounds.size.height) :
                                    CGRectMake(0, i*tmpSize.height, self.bounds.size.width, tmpSize.height))];
				[self addSubview:pageView];
				[_visiblePageSet addObject:pageView];
			}
		}
	}

}

#pragma mark - Getters

- (NSUInteger)currentPageIndex {
    if (self.frame.size.width <= 0 || self.frame.size.height <= 0)
        return 0;
    CGFloat fractionalOffset;
    if (_direction == EVPagingScrollViewDirectionHorizontal)
        fractionalOffset = (self.contentOffset.x / (_pageSize.width < 0 ? self.frame.size.width : _pageSize.width));
    else
        fractionalOffset = (self.contentOffset.y / (_pageSize.height < 0 ? self.frame.size.height : _pageSize.height));
    
    return (fractionalOffset < 0 ? 0 : floorf(fractionalOffset));    
}

- (EVPageView *)currentPageView {
    return [self pageViewForIndex:[self currentPageIndex]];
}

- (EVPageView *)pageViewForIndex:(NSUInteger)index {
    EVPageView *pageView = nil;
    for (pageView in _visiblePageSet) {
        if (pageView.pageNumber == index)
            break;
    }
    return pageView;
}

#pragma mark - Scroll View Control

- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self scrollToPage:pageIndex animated:animated completion:NULL];
}

- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    
    if (pageIndex < _pageCount) {
        CGSize size = _pageSize;
        if (_pageSize.width < 0 || _pageSize.height < 0)
            size = self.bounds.size;
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                [self setContentOffset:((_direction == EVPagingScrollViewDirectionHorizontal) ?
                                        CGPointMake(size.width * pageIndex, 0) :
                                        CGPointMake(0, size.height * pageIndex))];
            } completion:^(BOOL finished) {
                [self layoutIfNeeded];
                [self scrollViewDidEndDecelerating:self];
                if (completion)
                    completion(finished);
            }];
        } else {
            [self setContentOffset:((_direction == EVPagingScrollViewDirectionHorizontal) ?
                                    CGPointMake(size.width * pageIndex, 0) :
                                    CGPointMake(0, size.height * pageIndex))
                          animated:NO];
            [self layoutIfNeeded];
            [self scrollViewDidEndDecelerating:self];
            if (completion)
                completion(YES);
        }
//
//        if (!animated) {
//        }
    }    
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[self currentPageView] pageWillDisappear];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.pagingDelegate && [self.pagingDelegate respondsToSelector:@selector(pagingScrollView:didStopAtPage:)])
        [self.pagingDelegate pagingScrollView:self didStopAtPage:[self currentPageIndex]];
    
    [[self currentPageView] pageDidAppear];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self scrollViewDidEndDecelerating:self];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pagingDelegate && [self.pagingDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.pagingDelegate scrollViewDidScroll:self];
}


@end
