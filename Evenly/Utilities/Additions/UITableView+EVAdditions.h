//
//  UITableView+EVAdditions.h
//  Evenly
//
//  Created by Justin Brunet on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVGroupedTableViewCell.h"

@interface UITableView (EVAdditions)

@property (nonatomic, assign, getter=isLoading) BOOL loading;

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath;

@end
