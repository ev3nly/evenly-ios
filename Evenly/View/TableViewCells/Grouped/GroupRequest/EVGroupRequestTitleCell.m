//
//  EVGroupRequestTitleCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTitleCell.h"
#import "EVTextField.h"

@implementation EVGroupRequestTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 90.0, 44.0)];
        self.fieldLabel.font = [EVFont blackFontOfSize:14];
        self.fieldLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.fieldLabel];
    
        CGRect textFieldRect = CGRectMake(CGRectGetMaxX(self.fieldLabel.frame) + 10.0,
                                          10.0,
                                          self.contentView.frame.size.width - CGRectGetMaxX(self.fieldLabel.frame) - 20.0,
                                          24.0);
        self.textField = [[EVTextField alloc] initWithFrame:textFieldRect];
        self.textField.font = [EVFont defaultFontOfSize:14];
        [self.contentView addSubview:self.textField];
        
        self.position = EVGroupedTableViewCellPositionTop;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
