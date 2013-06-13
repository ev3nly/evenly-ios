//
//  EVNetworkSelectorCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNetworkSelectorCell.h"
#import "EVImages.h"

#define LABEL_X_ORIGIN 32
#define LABEL_INDENT 12
#define LABEL_RIGHT_BUFFER 10
#define LABEL_Y_OFFSET 2
#define LABEL_HUE (self.type == EVNetworkSelectorCellTypeCurrentSelection ? 160 : 50)

#define DROPDOWN_BUFFER 4
#define CHECK_BUFFER 10

@interface EVNetworkSelectorCell () {
    UIImageView *_privacyImageView;
    UIImageView *_dropdownArrow;
    UIImageView *_check;
    UILabel *_label;
}

- (void)loadImageView;
- (void)loadLabel;
- (void)loadDropdownArrow;
- (void)loadCheck;

- (void)addTapRecognizer;
- (void)handleTap;

- (UIImage *)imageForType:(EVNetworkSelectorCellType)type;
- (NSString *)textForType:(EVNetworkSelectorCellType)type;

- (CGRect)imageViewFrame;
- (CGRect)labelFrame;
- (CGRect)dropdownArrowFrame;
- (CGRect)checkFrame;

@end

@implementation EVNetworkSelectorCell

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame andType:(EVNetworkSelectorCellType)type
{
    if (self = [super initWithFrame:frame])
    {
        _type = type;
        if (type == EVNetworkSelectorCellTypeCurrentSelection)
            self.backgroundColor = [EVColor creamColor];
        
        [self loadImageView];
        [self loadLabel];
        
        if (type == EVNetworkSelectorCellTypeCurrentSelection)
            [self loadDropdownArrow];
        else if (type == EVNetworkSelectorCellTypeFriends)
            [self loadCheck];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dropdownArrow.frame = [self dropdownArrowFrame];
}

#pragma mark - View Loading

- (void)loadImageView
{
    _privacyImageView = [[UIImageView alloc] initWithImage:[self imageForType:self.type]];
    _privacyImageView.frame = [self imageViewFrame];
    _privacyImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_privacyImageView];
}

- (void)loadLabel
{
    _label = [UILabel new];
    _label.text = [self textForType:self.type];
    _label.textColor = EV_RGB_COLOR(LABEL_HUE, LABEL_HUE, LABEL_HUE);
    _label.font = [EVFont darkExchangeFormFont];
    _label.frame = [self labelFrame];
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
}

- (void)loadDropdownArrow
{
    _dropdownArrow = [[UIImageView alloc] initWithImage:[EVImages dropdownArrow]];
    _dropdownArrow.backgroundColor = [UIColor clearColor];
    _dropdownArrow.frame = [self dropdownArrowFrame];
    [self addSubview:_dropdownArrow];
}

- (void)loadCheck
{
    _check = [[UIImageView alloc] initWithImage:[EVImages checkIcon]];
    _check.backgroundColor = [UIColor clearColor];
    _check.frame = [self checkFrame];
    [self addSubview:_check];
}

#pragma mark - Tap Handling

- (void)addTapRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.type == EVNetworkSelectorCellTypeCurrentSelection) {
            _label.textColor = [UIColor blackColor];
        }
        else {
            self.backgroundColor = [UIColor grayColor];
        }
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateCancelled) {
        
    }
}

- (void)handleDeselection
{
    if (self.type == EVNetworkSelectorCellTypeCurrentSelection) {
        _label.textColor = [UIColor blackColor];
    }
    else {
        self.backgroundColor = [UIColor grayColor];
    }
}

#pragma mark - View Changing

- (void)showCheck
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _dropdownArrow.alpha = 1;
                     } completion:nil];
}

- (void)hideCheck
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _dropdownArrow.alpha = 0;
                     } completion:nil];
}

#pragma mark - Utility

- (UIImage *)imageForType:(EVNetworkSelectorCellType)type {
    switch (type) {
        case EVNetworkSelectorCellTypeCurrentSelection:
            return [EVImages lockIcon];
        case EVNetworkSelectorCellTypeFriends:
            return [EVImages friendsIcon];
        case EVNetworkSelectorCellTypeNetwork:
            return [EVImages globeIcon];
        case EVNetworkSelectorCellTypePrivate:
            return [EVImages lockIcon];
        default:
            return nil;
    }
}

- (NSString *)textForType:(EVNetworkSelectorCellType)type {
    switch (type) {
        case EVNetworkSelectorCellTypeCurrentSelection:
            return @"Current";
        case EVNetworkSelectorCellTypeFriends:
            return @"Friends";
        case EVNetworkSelectorCellTypeNetwork:
            return @"Network";
        case EVNetworkSelectorCellTypePrivate:
            return @"Private";
        default:
            return nil;
    }
}

#pragma mark - Frame Defines

- (CGRect)imageViewFrame {
    float indent = (self.type == EVNetworkSelectorCellTypeCurrentSelection) ? 0 : LABEL_INDENT;
    return CGRectMake(LABEL_X_ORIGIN/2 - _privacyImageView.image.size.width/2 + indent,
                      self.bounds.size.height/2 - _privacyImageView.image.size.height/2,
                      _privacyImageView.image.size.width,
                      _privacyImageView.image.size.height);
}

- (CGRect)labelFrame {
    float indent = (self.type == EVNetworkSelectorCellTypeCurrentSelection) ? 0 : LABEL_INDENT;
    return CGRectMake(LABEL_X_ORIGIN + indent,
                      LABEL_Y_OFFSET,
                      self.bounds.size.width - LABEL_X_ORIGIN - LABEL_RIGHT_BUFFER - indent,
                      self.bounds.size.height - LABEL_Y_OFFSET);
}

- (CGRect)dropdownArrowFrame {
    float labelWidth = [_label.text sizeWithFont:_label.font
                               constrainedToSize:CGSizeMake(self.bounds.size.width, _label.bounds.size.height)
                                   lineBreakMode:_label.lineBreakMode].width;
    return CGRectMake(_label.frame.origin.x + labelWidth + DROPDOWN_BUFFER,
                      self.bounds.size.height/2 - _dropdownArrow.image.size.height/2,
                      _dropdownArrow.image.size.width,
                      _dropdownArrow.image.size.height);
}

- (CGRect)checkFrame {
    return CGRectMake(CHECK_BUFFER,
                      self.bounds.size.height/2 - _check.image.size.height/2,
                      _check.image.size.width,
                      _check.image.size.height);
}

@end
