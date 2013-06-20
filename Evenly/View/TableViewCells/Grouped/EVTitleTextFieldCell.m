//
//  EVTitleTextFieldCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTitleTextFieldCell.h"

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
    
    float textWidth = [self.textLabel.text sizeWithFont:self.textLabel.font
                                      constrainedToSize:CGSizeMake(self.textLabel.frame.size.width, self.textLabel.frame.size.height) lineBreakMode:self.textLabel.lineBreakMode].width;
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
    _textField.font = [EVFont defaultFontOfSize:16];
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
    self.textLabel.font = [EVFont boldFontOfSize:16];
    self.textLabel.backgroundColor = [UIColor clearColor];
}

@end
