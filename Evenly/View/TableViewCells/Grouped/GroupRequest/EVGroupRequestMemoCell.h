//
//  EVGroupRequestMemoCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVPlaceholderTextView.h"

@interface EVGroupRequestMemoCell : EVGroupedTableViewCell

@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) EVPlaceholderTextView *textField;

@end
