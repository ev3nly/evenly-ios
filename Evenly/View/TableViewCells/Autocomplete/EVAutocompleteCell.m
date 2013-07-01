//
//  EVAutocompleteCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompleteCell.h"

@implementation EVAutocompleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^{
        self.backgroundColor = (selected ? [UIColor whiteColor] : [EVColor creamColor]);
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^{
        self.backgroundColor = (highlighted ? [UIColor whiteColor] : [EVColor creamColor]);
    }];
}

@end
