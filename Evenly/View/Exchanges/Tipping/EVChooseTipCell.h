//
//  EVChooseTipCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVTip;

@interface EVChooseTipCell : UICollectionViewCell

@property (nonatomic, strong) EVTip *tip;

+ (CGSize)sizeForTipCell;

@end
