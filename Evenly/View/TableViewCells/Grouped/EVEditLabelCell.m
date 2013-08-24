//
//  EVEditLabelCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditLabelCell.h"

#define LABEL_X_ORIGIN 20
#define AVATAR_LENGTH 80
#define AVATAR_BUFFER 10
#define SIDE_BUFFER 10

@implementation EVEditLabelCell

+ (float)cellHeight {
    return 54;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureTextLabel];
        [self loadTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = [self textLabelFrame];
    self.textField.frame = [self textFieldFrame];
}

#pragma mark - Setup

- (void)configureTextLabel {
    self.textLabel.text = @"Photo";
    self.textLabel.textColor = [EVColor darkLabelColor];
    self.textLabel.font = [EVFont blackFontOfSize:16];
    self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)loadTextField {
    self.textField = [EVTextField new];
    self.textField.text = @"";
    self.textField.textColor = [EVColor darkLabelColor];
    self.textField.font = [EVFont defaultFontOfSize:16];
    self.textField.delegate = self;
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.textField];
}

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self.textLabel.text = title;
    self.textField.placeholder = placeholder;
    [self setNeedsLayout];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(EVTextField *)textField {
    [self.textField resignFirstResponder];
    if (self.textField.next)
        [self.textField.next becomeFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.handleTextChange)
        self.handleTextChange(textField.text);
    return YES;
}

#pragma mark - Frames

- (CGRect)textLabelFrame {
    [self.textLabel sizeToFit];
    return CGRectMake(LABEL_X_ORIGIN,
                      CGRectGetMidY(self.bounds) - self.textLabel.bounds.size.height/2,
                      self.textLabel.bounds.size.width,
                      self.textLabel.bounds.size.height);
}

- (CGRect)textFieldFrame {
    float xOrigin = CGRectGetMaxX(self.textLabel.frame) + SIDE_BUFFER;
    return CGRectMake(xOrigin,
                      self.textLabel.frame.origin.y,
                      self.bounds.size.width - SIDE_BUFFER*2 - xOrigin,
                      self.textLabel.bounds.size.height);
}

@end
