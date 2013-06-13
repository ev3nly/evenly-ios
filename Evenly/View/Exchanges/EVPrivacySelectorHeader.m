//
//  EVPrivacySelectorCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPrivacySelectorHeader.h"
#import "EVImages.h"

#define DROPDOWN_BUFFER 4

@interface EVPrivacySelectorHeader () {
    UIImageView *_dropdownArrow;
}

- (void)loadDropdownArrow;

- (CGRect)dropdownArrowFrame;

@end

@implementation EVPrivacySelectorHeader

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame andSetting:(EVPrivacySetting)setting
{
    if (self = [super initWithFrame:frame andSetting:setting])
    {
        self.backgroundColor = [EVColor creamColor];
        
        [self loadDropdownArrow];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dropdownArrow.frame = [self dropdownArrowFrame];
}

#pragma mark - View Loading

- (void)loadDropdownArrow
{
    _dropdownArrow = [[UIImageView alloc] initWithImage:[EVImages dropdownArrow]];
    _dropdownArrow.backgroundColor = [UIColor clearColor];
    _dropdownArrow.frame = [self dropdownArrowFrame];
    [self addSubview:_dropdownArrow];
}

#pragma mark - Tap Handling

- (void)handleTouchUpInside
{
    [self.window findAndResignFirstResponder];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.label.textColor = [UIColor blackColor];
    }
    else {
        self.label.textColor = [self labelColor];
    }
}

#pragma mark - Frame Defines

- (CGRect)dropdownArrowFrame {
    float labelWidth = [self.label.text sizeWithFont:self.label.font
                               constrainedToSize:CGSizeMake(self.bounds.size.width, self.label.bounds.size.height)
                                   lineBreakMode:self.label.lineBreakMode].width;
    return CGRectMake(self.label.frame.origin.x + labelWidth + DROPDOWN_BUFFER,
                      self.bounds.size.height/2 - _dropdownArrow.image.size.height/2,
                      _dropdownArrow.image.size.width,
                      _dropdownArrow.image.size.height);
}

@end
