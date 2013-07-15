//
//  EVGroupRequestTierAssignmentView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVGroupRequestTierAssignmentViewCell.h"

@class EVGroupRequestTierAssignmentView;

@protocol EVGroupRequestTierAssignmentDataSource <NSObject>

- (NSArray *)fullMembershipForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view;
- (NSArray *)assignmentsForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view;
- (NSInteger)tierIndexForTierAssignmentView:(EVGroupRequestTierAssignmentView *)view;

@end

@protocol EVGroupRequestTierAssignmentDelegate <NSObject>

- (void)tierAssignmentView:(EVGroupRequestTierAssignmentView *)view didSelectMemberAtIndex:(NSInteger)index;

@end

@interface EVGroupRequestTierAssignmentView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<EVGroupRequestTierAssignmentDataSource> dataSource;
@property (nonatomic, weak) id<EVGroupRequestTierAssignmentDelegate> delegate;

- (void)reloadData;

@end
