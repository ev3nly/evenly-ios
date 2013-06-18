//
//  EVPageView.h
//  TCTouch
//
//  Created by Joseph Hankin on 1/27/12.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVPageView : UIView {
    NSString *_reuseIdentifier;
    NSInteger _pageNumber;
    NSIndexPath *_indexPath;
}

@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;

- (void)pageWillDisappear;
- (void)pageDidAppear;

@end
