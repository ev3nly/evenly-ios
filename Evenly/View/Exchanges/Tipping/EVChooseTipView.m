//
//  EVChooseTipView.m
//  Evenly
//
//  Created by Justin Brunet on 7/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVChooseTipView.h"
#import "EVChooseTipCell.h"
#import "EVTip.h"

#define COLLECTION_VIEW_SIDE_BUFFER 14
#define COLLECTION_VIEW_TOP_BUFFER 14

@implementation EVChooseTipView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadCollectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = [self collectionViewFrame];
}

- (void)loadCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setSectionInset:UIEdgeInsetsMake(COLLECTION_VIEW_TOP_BUFFER, COLLECTION_VIEW_SIDE_BUFFER, COLLECTION_VIEW_TOP_BUFFER, COLLECTION_VIEW_SIDE_BUFFER)];
    [layout setItemSize:[EVChooseTipCell sizeForTipCell]];
    layout.minimumLineSpacing = 40;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[self collectionViewFrame] collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[EVChooseTipCell class] forCellWithReuseIdentifier:@"chooseTipCell"];
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EVChooseTipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chooseTipCell" forIndexPath:indexPath];
    cell.tip = [self.tips objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EVChooseTipCell *cell = (EVChooseTipCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedTip = cell.tip;
}

- (CGRect)collectionViewFrame {
    return self.bounds;
}

@end
