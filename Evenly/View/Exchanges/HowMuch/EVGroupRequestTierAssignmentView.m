//
//  EVGroupRequestTierAssignmentView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTierAssignmentView.h"

@implementation EVGroupRequestTierAssignmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = EV_RGB_ALPHA_COLOR(36, 45, 50, 0.6);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        [layout setItemSize:CGSizeMake(65, 80)];
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                 collectionViewLayout:layout];
        [self.collectionView registerClass:[EVGroupRequestTierAssignmentViewCell class]
                forCellWithReuseIdentifier:@"avatarCell"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = EV_RGB_ALPHA_COLOR(36, 45, 50, 0.95);
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[self.dataSource fullMembershipForTierAssignmentView:self] count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EVObject<EVExchangeable> *modelObject = [[self.dataSource fullMembershipForTierAssignmentView:self] objectAtIndex:indexPath.item];
    
    EVGroupRequestTierAssignmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"avatarCell"
                                                                                           forIndexPath:indexPath];
    [cell setContact:modelObject];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate tierAssignmentView:self didSelectMemberAtIndex:indexPath.item];
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
