//
//  EVGettingStartedCell.m
//  Evenly
//
//  Created by Justin Brunet on 8/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGettingStartedCell.h"

#define GS_BUTTON_WIDTH 70
#define GS_BUTTON_HEIGHT 34
#define GS_BUTTON_MARGIN 10

#define GS_TABLE_VIEW_MARGIN 10
#define GS_TEXT_SIDE_BUFFER 10

@interface EVGettingStartedCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation EVGettingStartedCell

+ (float)cellHeight {
    return 54;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadTitleLabel];
        [self loadSubtitleLabel];
        [self loadButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = [self titleLabelFrame];
    self.subtitleLabel.frame = [self subtitleLabelFrame];
    self.button.frame = [self buttonFrame];
}

#pragma mark - View Loading

- (void)loadTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [EVColor darkLabelColor];
    self.titleLabel.font = [EVFont boldFontOfSize:15];
    [self addSubview:self.titleLabel];
}

- (void)loadSubtitleLabel {
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.textColor = [EVColor darkLabelColor];
    self.subtitleLabel.font = [EVFont defaultFontOfSize:13];
    [self addSubview:self.subtitleLabel];
}

- (void)loadButton {
    self.button = [UIButton new];
    [self.button setBackgroundImage:[EVImages inviteButtonBackground] forState:UIControlStateNormal];
    [self.button setBackgroundImage:[EVImages inviteButtonBackgroundSelected] forState:UIControlStateHighlighted];
    [self.button addTarget:self action:@selector(performAction) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:[self buttonTextForStep:self.step] forState:UIControlStateNormal];
    [self.button setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    [self.button setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    self.button.titleLabel.font = [EVFont blackFontOfSize:12];
    [self addSubview:self.button];
}

#pragma mark - Setters and Actions

- (void)setStep:(EVGettingStartedStep)step {
    _step = step;
    
    self.titleLabel.text = [self titleForStep:step];
    self.subtitleLabel.text = [self subtitleForStep:step];
    [self configureButton];
    [self setNeedsLayout];
}

- (void)setCompleted:(BOOL)completed {
    _completed = completed;
    
    [self configureButton];
    [self setNeedsLayout];
}

- (void)performAction {
    if (self.action && !self.completed)
        self.action(self.step);
}

- (void)configureButton {
    if (self.completed) {
        [self.button setTitle:@"" forState:UIControlStateNormal];
        [self.button setBackgroundImage:[EVImages greenCheck] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[EVImages greenCheck] forState:UIControlStateHighlighted];
    } else {
        [self.button setBackgroundImage:[EVImages inviteButtonBackground] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[EVImages inviteButtonBackgroundSelected] forState:UIControlStateHighlighted];
        [self.button setTitle:[self buttonTextForStep:self.step] forState:UIControlStateNormal];
    }
    self.button.frame = [self buttonFrame];
}

#pragma mark - Strings For Steps

- (NSString *)titleForStep:(EVGettingStartedStep)step {    
    switch (step) {
        case EVGettingStartedStepSignUp:
            return @"Sign up for Evenly";
        case EVGettingStartedStepConfirmEmail:
            return @"Confirm your email address";
        case EVGettingStartedStepConnectFacebook:
            return @"Connect with Facebook";
        case EVGettingStartedStepAddCard:
            return @"Add a card";
        case EVGettingStartedStepInviteFriends:
            return @"Invite your friends";
        case EVGettingStartedStepSendPayment:
            return @"Send a payment";
        case EVGettingStartedStepSendRequest:
            return @"Send a request";
        case EVGettingStartedStepAddBank:
            return @"Add a bank";
        default:
            return @"";
    }
}

- (NSString *)subtitleForStep:(EVGettingStartedStep)step {
    switch (step) {
        case EVGettingStartedStepSignUp:
            return @"";
        case EVGettingStartedStepConfirmEmail:
            return @"Check for an email from Evenly";
        case EVGettingStartedStepConnectFacebook:
            return @"Share the experience with friends";
        case EVGettingStartedStepAddCard:
            return @"Use any debit or credit card";
        case EVGettingStartedStepInviteFriends:
            return @"Evenly is more fun with friends!";
        case EVGettingStartedStepSendPayment:
            return @"It only takes 10 seconds";
        case EVGettingStartedStepSendRequest:
            return @"Get your money back!";
        case EVGettingStartedStepAddBank:
            return @"Begin depositing your Evenly Cash";
        default:
            return @"";
    }
}

- (NSString *)buttonTextForStep:(EVGettingStartedStep)step {
    switch (step) {
        case EVGettingStartedStepSignUp:
            return @"Sign Up";
        case EVGettingStartedStepConfirmEmail:
            return @"Resend";
        case EVGettingStartedStepConnectFacebook:
            return @"Connect";
        case EVGettingStartedStepAddCard:
            return @"Add";
        case EVGettingStartedStepInviteFriends:
            return @"Invite";
        case EVGettingStartedStepSendPayment:
            return @"Pay";
        case EVGettingStartedStepSendRequest:
            return @"Request";
        case EVGettingStartedStepAddBank:
            return @"Add";
        default:
            return @"";
    }
}

#pragma mark - Frames

- (CGRect)titleLabelFrame {
    [self.titleLabel sizeToFit];
    [self.subtitleLabel sizeToFit];
    float totalTextHeight = self.titleLabel.bounds.size.height + self.subtitleLabel.bounds.size.height;
    return CGRectMake(GS_TABLE_VIEW_MARGIN + GS_TEXT_SIDE_BUFFER,
                      CGRectGetMidY(self.bounds) - totalTextHeight/2,
                      self.titleLabel.bounds.size.width,
                      self.titleLabel.bounds.size.height);
}

- (CGRect)subtitleLabelFrame {
    [self.subtitleLabel sizeToFit];
    return CGRectMake(self.titleLabel.frame.origin.x,
                      CGRectGetMaxY(self.titleLabel.frame),
                      self.subtitleLabel.bounds.size.width,
                      self.subtitleLabel.bounds.size.height);
}

- (CGRect)buttonFrame {
    CGSize buttonSize = CGSizeMake(GS_BUTTON_WIDTH, self.bounds.size.height - GS_BUTTON_MARGIN*2);
    if (self.completed)
        buttonSize = [EVImages greenCheck].size;
    return CGRectMake(self.bounds.size.width - GS_BUTTON_MARGIN - GS_BUTTON_WIDTH/2 - buttonSize.width/2 - GS_TABLE_VIEW_MARGIN,
                      CGRectGetMidY(self.bounds) - buttonSize.height/2,
                      buttonSize.width,
                      buttonSize.height);
}

@end
