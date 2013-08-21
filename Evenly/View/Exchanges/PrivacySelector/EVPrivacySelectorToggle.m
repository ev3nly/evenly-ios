//
//  EVPrivacySelectorToggle.m
//  Evenly
//
//  Created by Justin Brunet on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPrivacySelectorToggle.h"
#import "EVSwitch.h"
#import "EVCIA.h"

#define LABEL_X_ORIGIN 10
#define LABEL_RIGHT_BUFFER 10
#define LABEL_Y_OFFSET 2

@interface EVPrivacySelectorToggle ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) EVSwitch *toggle;
@end

@implementation EVPrivacySelectorToggle

+ (int)numberOfLines {
    return 1;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [EVColor creamColor];
        [self loadLabel];
        [self loadToggle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = [self labelFrame];
    self.toggle.frame = [self toggleFrame];
}

- (void)loadLabel {
    self.label = [UILabel new];
    self.label.text = @"Share With Friends";
    self.label.textColor = [EVColor lightLabelColor];
    self.label.font = [EVFont darkExchangeFormFont];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

- (void)loadToggle {
    self.toggle = [EVSwitch new];
    [self.toggle addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.toggle];
    
    BOOL toggleOn = ([EVCIA me].privacySetting == EVPrivacySettingPrivate) ? NO : YES;
    [self.toggle setOn:toggleOn animated:NO];
}

- (void)loadCells {
    //toggle doesn't need cells
}

- (void)switchChanged:(EVSwitch *)toggle {
    [EVCIA me].privacySetting = toggle.on ? EVPrivacySettingFriends : EVPrivacySettingPrivate;
}

- (CGRect)labelFrame {
    return CGRectMake(LABEL_X_ORIGIN,
                      LABEL_Y_OFFSET,
                      self.bounds.size.width - LABEL_X_ORIGIN - LABEL_RIGHT_BUFFER,
                      self.bounds.size.height - LABEL_Y_OFFSET);
}

- (CGRect)toggleFrame {
    [self.toggle sizeToFit];
    return CGRectMake(self.bounds.size.width - LABEL_X_ORIGIN - self.toggle.bounds.size.width,
                      CGRectGetMidY(self.bounds) - self.toggle.bounds.size.height/2,
                      self.toggle.bounds.size.width,
                      self.toggle.bounds.size.height);
}

@end
