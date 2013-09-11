//
//  EVDepositCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDepositCell.h"

#define SIDE_MARGIN 20
#define DEPOSIT_LABEL_WIDTH 150
#define DEPOSIT_LABEL_HEIGHT 44

@implementation EVDepositCell

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self setFrame:frame];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat fontSize = 15.0;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_MARGIN, 0, DEPOSIT_LABEL_WIDTH, DEPOSIT_LABEL_HEIGHT)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [EVFont blackFontOfSize:fontSize];
        [self.contentView addSubview:self.label];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.font = [EVFont defaultFontOfSize:fontSize];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.textField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float textWidth = [self.label.text _safeBoundingRectWithSize:CGSizeMake(self.label.frame.size.width, self.label.frame.size.height)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: self.label.font}
                                                         context:NULL].size.width;
    float textFieldOrigin = self.label.frame.origin.x + textWidth + 20;
    
    self.textField.frame = CGRectMake(textFieldOrigin,
                                      0,
                                      self.bounds.size.width - textFieldOrigin - 20,
                                      self.bounds.size.height);
}

@end
