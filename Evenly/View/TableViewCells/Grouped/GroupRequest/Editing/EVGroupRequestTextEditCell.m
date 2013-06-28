//
//  EVGroupRequestTextEditCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/28/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTextEditCell.h"

@implementation EVGroupRequestTextEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 90.0, 44.0)];
        self.fieldLabel.font = [EVFont blackFontOfSize:14];
        self.fieldLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.fieldLabel];
    
    }
    return self;
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
