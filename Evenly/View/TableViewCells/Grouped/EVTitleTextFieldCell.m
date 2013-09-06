//
//  EVTitleTextFieldCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTitleTextFieldCell.h"

#define SIDE_MARGIN ([EVUtilities userHasIOS7] ? 20 : 10)

@implementation EVTitleTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureTextField];
        [self configureTextLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = [self textLabelFrame];
    float textWidth = [self.textLabel.text _safeBoundingRectWithSize:CGSizeMake(self.textLabel.frame.size.width, self.textLabel.frame.size.height)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName: self.textLabel.font}
                                                             context:NULL].size.width;
    float textFieldOrigin = self.textLabel.frame.origin.x + textWidth + 20;
    
    self.textField.frame = CGRectMake(textFieldOrigin,
                                      0,
                                      self.bounds.size.width - textFieldOrigin - 20,
                                      self.bounds.size.height);
}

- (void)configureTextField
{
    self.textField = [[EVTextField alloc] initWithFrame:CGRectZero];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [EVFont defaultFontOfSize:15];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:_textField];
}

- (void)configureTextLabel
{
    self.textLabel.textColor = [EVColor newsfeedNounColor];
    self.textLabel.font = [EVFont blackFontOfSize:15];
    self.textLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - Frames

- (CGRect)textLabelFrame {
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = SIDE_MARGIN;
    return textFrame;
}

@end
