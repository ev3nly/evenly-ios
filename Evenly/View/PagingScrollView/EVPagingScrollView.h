//
//  EVPagingScrollView.h
//  TCTouch
//
//  Created by Joseph Hankin on 1/27/12.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EVPagingScrollViewDirectionHorizontal = 0,
    EVPagingScrollViewDirectionVertical
} EVPagingScrollViewDirection;

@class EVPagingScrollView;
@class EVPageView;

@protocol EVPagingScrollViewDataSource <NSObject>

- (NSUInteger)numberOfPagesInPagingScrollView:(EVPagingScrollView *)scrollView;
- (EVPageView *)pagingScrollView:(EVPagingScrollView *)scrollView pageViewForIndex:(NSUInteger)index;

@end

@protocol EVPagingScrollViewDelegate <NSObject>
@optional
- (void)pagingScrollView:(EVPagingScrollView *)scrollView didStopAtPage:(NSUInteger)page;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface EVPagingScrollView : UIScrollView <UIScrollViewDelegate> {
    __weak NSObject<EVPagingScrollViewDelegate> *_pagingDelegate;
    __weak NSObject<EVPagingScrollViewDataSource> *_dataSource;
    NSMutableSet *_visiblePageSet;
    NSMutableSet *_reusablePageSet;
    
    NSInteger _pageCount;
    CGSize _pageSize;
    EVPagingScrollViewDirection _direction;
    
    NSUInteger _lookAhead;
    NSUInteger _lookBehind;
}

@property (nonatomic, weak) NSObject<EVPagingScrollViewDelegate> *pagingDelegate;
@property (nonatomic, weak) NSObject<EVPagingScrollViewDataSource> *dataSource;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) NSUInteger lookAhead;
@property (nonatomic, assign) NSUInteger lookBehind;

- (id)initWithFrame:(CGRect)frame direction:(EVPagingScrollViewDirection)direction;
- (void)reloadData;
- (EVPageView *)dequeueReusableViewWithIdentifier:(NSString *)identifier;
- (NSUInteger)currentPageIndex;
- (EVPageView *)currentPageView;
- (EVPageView *)pageViewForIndex:(NSUInteger)index;

- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated;
- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
