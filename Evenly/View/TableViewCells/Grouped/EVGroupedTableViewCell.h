//
//  EVGroupedTableViewCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    EVGroupedTableViewCellPositionTop,
    EVGroupedTableViewCellPositionCenter,
    EVGroupedTableViewCellPositionBottom,
    EVGroupedTableViewCellPositionSingle
} EVGroupedTableViewCellPosition;

@interface EVGroupedTableViewCell : UITableViewCell

@property (nonatomic) EVGroupedTableViewCellPosition position;
@property (nonatomic, readonly) CGRect visibleFrame;

@end

@interface EVGroupedTableViewCellBackground : UIView

@property (nonatomic) EVGroupedTableViewCellPosition position;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;

@end