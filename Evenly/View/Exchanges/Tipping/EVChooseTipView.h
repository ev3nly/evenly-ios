//
//  EVChooseTipView.h
//  Evenly
//
//  Created by Justin Brunet on 7/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVTip;

@interface EVChooseTipView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) EVTip *selectedTip;
@property (nonatomic, strong) NSArray *tips;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
