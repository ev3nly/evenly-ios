//
//  EVGroupRequestTextEditCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/28/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVGroupRequestTextEditCell : EVGroupedTableViewCell

@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) EVHandleTextChangeBlock handleTextChange;

@end
