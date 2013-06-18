//
//  EVRequestInitialView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestInitialView.h"

#define REQUEST_SWITCH_HEIGHT 45

#define LEFT_RIGHT_BUFFER 10
#define TO_FIELD_HEIGHT 25
#define LINE_HEIGHT 40
#define INSTRUCTION_LABEL_BUFFER 30.0

@interface EVRequestInitialView ()

@property (nonatomic, strong) UIView *requestSwitchBackground;
@property (nonatomic, strong) UIView *upperStripe;
@property (nonatomic, strong) UIView *lowerStripe;

@end

@implementation EVRequestInitialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.text = @"Who owes you money?";

        [self loadRequestSwitch];
        [self loadToField];
        [self loadInstructionLabel];
    }
    return self;
}

- (void)loadRequestSwitch {
    self.requestSwitchBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                            CGRectGetMaxY(self.titleLabel.frame),
                                                                            self.frame.size.width,
                                                                            REQUEST_SWITCH_HEIGHT)];
    self.requestSwitchBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:self.requestSwitchBackground];
    
    self.requestSwitch = [[EVRequestSwitch alloc] initWithFrame:[self requestSwitchFrame]];
    self.requestSwitch.delegate = self;
    [self.requestSwitchBackground addSubview:self.requestSwitch];
    
    [RACAble(self.requestSwitch.xPercentage) subscribeNext:^(NSNumber *percentage) {
        self.instructionLabel.alpha = [percentage floatValue];
    }];
}

- (void)switchControl:(EVSwitch *)switchControl willChangeStateTo:(BOOL)onOff animationDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                     animations:^{
                         self.instructionLabel.alpha = (float)onOff;
                     }];
}

- (CGRect)requestSwitchFrame {
    return CGRectMake(10, 7, 300, 35);
}


- (void)loadToField
{
    self.upperStripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                CGRectGetMaxY(self.requestSwitchBackground.frame) + EV_REQUEST_VIEW_LABEL_FIELD_BUFFER,
                                                                self.frame.size.width,
                                                                1)];
    self.upperStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.upperStripe];
    
    self.toField = [self configuredTextField];
    self.toField.placeholder = @"Name, email, phone number";
    self.toField.frame = CGRectMake(LEFT_RIGHT_BUFFER,
                                    CGRectGetMaxY(self.upperStripe.frame) + EV_REQUEST_VIEW_LABEL_FIELD_BUFFER,
                                    self.frame.size.width - 2*LEFT_RIGHT_BUFFER,
                                    TO_FIELD_HEIGHT);
    self.toField.returnKeyType = UIReturnKeyNext;
    self.toField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.toField];
    [self.toField becomeFirstResponder];
    


    self.lowerStripe = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toField.frame) + 2.0, self.frame.size.width, 1)];
    self.lowerStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.lowerStripe];
}

- (void)loadInstructionLabel {
    self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(INSTRUCTION_LABEL_BUFFER,
                                                                      CGRectGetMaxY(self.lowerStripe.frame),
                                                                      self.frame.size.width - 2*INSTRUCTION_LABEL_BUFFER,
                                                                      self.frame.size.height - CGRectGetMaxY(self.toField.frame))];
    self.instructionLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.textColor = [EVColor lightLabelColor];
    self.instructionLabel.font = [EVFont boldFontOfSize:16];
    self.instructionLabel.backgroundColor = [UIColor clearColor];
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.instructionLabel.text = @"Add friends now or invite them later on.";
    self.instructionLabel.alpha = 0.0;
    [self addSubview:self.instructionLabel];
    
}

- (EVTextField *)configuredTextField {
    EVTextField *textField = [EVTextField new];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = EV_RGB_COLOR(180, 180, 180);
    textField.font = [EVFont lightExchangeFormFont];
    return textField;
}

- (BOOL)isFirstResponder {
    return self.toField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.toField becomeFirstResponder];
}

@end
