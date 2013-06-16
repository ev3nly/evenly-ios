//
//  EVGroupTableViewCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    EVGroupTableViewCellPositionTop,
    EVGroupTableViewCellPositionCenter,
    EVGroupTableViewCellPositionBottom,
    EVGroupTableViewCellPositionSingle
} EVGroupTableViewCellPosition;

@interface EVGroupTableViewCell : UITableViewCell

@property (nonatomic) EVGroupTableViewCellPosition position;

@end

@interface EVGroupTableViewCellBackground : UIView

@property (nonatomic) EVGroupTableViewCellPosition position;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;

@end