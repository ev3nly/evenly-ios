//
//  EVGroupRequestCompletedCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestCompletedCell.h"

@implementation EVGroupRequestCompletedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        label.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [EVColor darkLabelColor];
        label.font = [EVFont blackFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"COMPLETED!";
        [self.contentView addSubview:label];
        
        self.position = EVGroupedTableViewCellPositionBottom;
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
