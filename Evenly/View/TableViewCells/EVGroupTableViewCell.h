//
//  EVGroupTableViewCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVGroupTableViewCell : UITableViewCell

@end

typedef enum{
    EVGroupTableViewCellPositionTop,
    EVGroupTableViewCellPositionCenter,
    EVGroupTableViewCellPositionBottom
} EVGroupTableViewCellPosition;

@interface EVGroupTableViewCellBackground : UIView

@property (nonatomic) EVGroupTableViewCellPosition position;

@end