//
//  UITableView+EVAdditions.m
//  Evenly
//
//  Created by Justin Brunet on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "UITableView+EVAdditions.h"
#import "EVLoadingIndicator.h"
#import "EVPrivacyNotice.h"

#define LOADING_INDICATOR_TAG 2947

#define MESSAGE_TOP_MARGIN 10.0
#define MESSAGE_SIDE_MARGIN 10.0
#define MESSAGE_HEIGHT 44.0

@implementation UITableView (EVAdditions)

@dynamic loading;

- (void)setLoading:(BOOL)loading {
    if (loading) {
        for (UIView *subview in self.subviews) {
            if (subview.tag == LOADING_INDICATOR_TAG)
                return;
        }
        
        EVLoadingIndicator *indicator = [EVLoadingIndicator new];
        indicator.tag = LOADING_INDICATOR_TAG;
        indicator.autoresizingMask = EV_AUTORESIZE_TO_CENTER;
        [self addSubview:indicator];
        [indicator sizeToFit];
        indicator.frame = CGRectMake(CGRectGetMidX(self.bounds) - indicator.bounds.size.width/2,
                                     CGRectGetMidY(self.bounds) - indicator.bounds.size.height/2 + self.loadingIndicatorYOffset,
                                     indicator.bounds.size.width,
                                     indicator.bounds.size.height);
        [indicator startAnimating];
    }
    else {
        for (UIView *subview in self.subviews) {
            if (subview.tag == LOADING_INDICATOR_TAG) {
                EVLoadingIndicator *indicator = (EVLoadingIndicator *)subview;
                [indicator removeFromSuperview];
            }
        }
    }
}

- (BOOL)isLoading {
    for (UIView *subview in self.subviews) {
        if (subview.tag == LOADING_INDICATOR_TAG) {
            return YES;
        }
    }
    return NO;
}

static char _loadingIndicatorYOffset;

- (void)setLoadingIndicatorYOffset:(float)loadingIndicatorYOffset {
    objc_setAssociatedObject(self, &_loadingIndicatorYOffset, [NSNumber numberWithFloat:loadingIndicatorYOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)loadingIndicatorYOffset {
    NSNumber *offset = objc_getAssociatedObject(self, &_loadingIndicatorYOffset);
    return [offset floatValue];
}

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self.dataSource tableView:self numberOfRowsInSection:indexPath.section];
    if (rowCount <= 1)
        return EVGroupedTableViewCellPositionSingle;
    else {
        if (indexPath.row == 0)
            return EVGroupedTableViewCellPositionTop;
        else if (indexPath.row == rowCount - 1)
            return EVGroupedTableViewCellPositionBottom;
        else
            return EVGroupedTableViewCellPositionCenter;
    }
}

- (void)addReassuringMessage {
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.bounds.size.width,
                                                                    MESSAGE_HEIGHT + MESSAGE_TOP_MARGIN)];
    EVPrivacyNotice *privacyNotice = [[EVPrivacyNotice alloc] initWithFrame:CGRectMake(MESSAGE_SIDE_MARGIN,
                                                                                       MESSAGE_TOP_MARGIN,
                                                                                       self.bounds.size.width - 2*MESSAGE_SIDE_MARGIN,
                                                                                       MESSAGE_HEIGHT)];
    privacyNotice.label.text = @"Evenly uses bank-level, 256-bit encryption to protect your information.";
    [self.tableFooterView addSubview:privacyNotice];
}

@end
