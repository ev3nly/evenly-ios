//
//  EVGroupRequestMemoCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestMemoCell.h"

@implementation EVGroupRequestMemoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect textFieldRect = CGRectMake(CGRectGetMaxX(self.fieldLabel.frame) + 2.0,
                                          0.0,
                                          self.contentView.frame.size.width - CGRectGetMaxX(self.fieldLabel.frame) - 25.0,
                                          74.0);
        self.textField = [[EVPlaceholderTextView alloc] initWithFrame:textFieldRect];
        self.textField.font = [EVFont defaultFontOfSize:14];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.delegate = self;
        [self.contentView addSubview:self.textField];
        
        self.position = EVGroupedTableViewCellPositionBottom;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.handleTextChange)
        self.handleTextChange(textView.text);
    return YES;
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
