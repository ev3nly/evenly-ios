//
//  EVProfileCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProfileCell.h"
#import "EVAvatarView.h"
#import "EVProfileViewController.h"

#define PROFILE_AVATAR_CORNER_RADIUS 8.0
#define PROFILE_AVATAR_BUFFER 10
#define PROFILE_AVATAR_LENGTH 80
#define PROFILE_FONT_SIZE 15
#define PROFILE_EXTRA_TOTAL_LABEL_HEIGHT 4

@interface EVProfileCell ()

@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *networkLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;

@property (nonatomic, strong) UIButton *chargeButton;

@end

@implementation EVProfileCell

+ (float)cellHeightForUser:(EVUser *)user {
    return (PROFILE_AVATAR_BUFFER + PROFILE_AVATAR_LENGTH + PROFILE_AVATAR_BUFFER + [EVImages grayButtonBackground].size.height + PROFILE_AVATAR_BUFFER);
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self loadAvatarView];
        [self loadNameLabel];
        [self loadNetworkLabel];
        [self loadEmailLabel];
        [self loadPhoneNumberLabel];
        [self loadProfileButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarView.frame = [self avatarViewFrame];
    self.nameLabel.frame = [self nameLabelFrame];
    self.networkLabel.frame = [self networkLabelFrame];
    self.emailLabel.frame = [self emailLabelFrame];
    self.phoneNumberLabel.frame = [self phoneNumberLabelFrame];
    self.chargeButton.frame = [self chargeButtonFrame];
    self.profileButton.frame = [self profileButtonFrame];
}

#pragma mark - Loading

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:self.bounds];
    self.avatarView.cornerRadius = PROFILE_AVATAR_CORNER_RADIUS;
    [self addSubview:self.avatarView];
}

- (void)loadNameLabel {
    self.nameLabel = [self configuredLabel];
    self.nameLabel.font = [EVFont blackFontOfSize:PROFILE_FONT_SIZE];
    self.nameLabel.textColor = [EVColor darkLabelColor];
    [self addSubview:self.nameLabel];
}

- (void)loadNetworkLabel {
    self.networkLabel = [self configuredLabel];
    [self addSubview:self.networkLabel];
}

- (void)loadEmailLabel {
    self.emailLabel = [self configuredLabel];
    [self addSubview:self.emailLabel];
}

- (void)loadPhoneNumberLabel {
    self.phoneNumberLabel = [self configuredLabel];
    [self addSubview:self.phoneNumberLabel];
}

#define SETTINGS_GEAR_TAG 3028

- (void)loadProfileButton {
    self.profileButton = [UIButton new];
    [self.profileButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
    [self.profileButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.profileButton addTarget:self.parent action:@selector(editProfileButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.profileButton setTitle:@"EDIT PROFILE" forState:UIControlStateNormal];
    [self.profileButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    self.profileButton.titleLabel.font = [EVFont blackFontOfSize:14];
    [self addSubview:self.profileButton];
    
    UIImageView *settingsIcon = [[UIImageView alloc] initWithImage:[EVImageUtility overlayImage:[EVImages settingsIcon]
                                                                                      withColor:[UIColor lightGrayColor]
                                                                                     identifier:@"settingsIcon"]];
    float midPoint = [EVImages grayButtonBackground].size.height/2;
    settingsIcon.frame = CGRectMake(midPoint - [EVImages settingsIcon].size.width/2,
                                    midPoint - [EVImages settingsIcon].size.height/2,
                                    [EVImages settingsIcon].size.width,
                                    [EVImages settingsIcon].size.height);
    settingsIcon.tag = SETTINGS_GEAR_TAG;
    [self.profileButton addSubview:settingsIcon];
}

- (void)loadChargeButton {
    self.chargeButton = [UIButton new];
    [self.chargeButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
    [self.chargeButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.chargeButton addTarget:self action:@selector(chargeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.chargeButton setTitle:@"REQUEST" forState:UIControlStateNormal];
    [self.chargeButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    self.chargeButton.titleLabel.font = [EVFont blackFontOfSize:14];
    [self addSubview:self.chargeButton];    
}

- (UILabel *)configuredLabel {
    UILabel *label = [UILabel new];
    label.textColor = [EVColor lightLabelColor];
    label.font = [EVFont defaultFontOfSize:PROFILE_FONT_SIZE];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - Setters

- (void)setUser:(EVUser *)user {
    _user = user;
    
    self.avatarView.avatarOwner = user;
    self.nameLabel.text = user.name;
    self.networkLabel.text = @"Network?";
    self.emailLabel.text = user.email;
    self.phoneNumberLabel.text = [EVStringUtility displayStringForPhoneNumber:user.phoneNumber];
    
    if (![user.dbid isEqualToString:[EVCIA me].dbid]) {
        if ([self.profileButton viewWithTag:SETTINGS_GEAR_TAG])
            [[self.profileButton viewWithTag:SETTINGS_GEAR_TAG] removeFromSuperview];
        [self.profileButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
        [self.profileButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
        [self.profileButton setTitle:@"PAY" forState:UIControlStateNormal];
        [self.profileButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
        [self.profileButton removeTarget:self.parent action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.profileButton addTarget:self action:@selector(payButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadChargeButton];
    }
}

#pragma mark - Button Handling

- (void)chargeButtonTapped {
    if (self.handleChargeUser)
        self.handleChargeUser();
}

- (void)payButtonTapped {
    if (self.handlePayUser)
        self.handlePayUser();
}

#pragma mark - Frames

- (CGRect)avatarViewFrame {
    self.avatarView.size = CGSizeMake(PROFILE_AVATAR_LENGTH, PROFILE_AVATAR_LENGTH);
    return CGRectMake(PROFILE_AVATAR_BUFFER*2,
                      PROFILE_AVATAR_BUFFER,
                      PROFILE_AVATAR_LENGTH,
                      PROFILE_AVATAR_LENGTH);
}

- (CGRect)nameLabelFrame {
    return CGRectMake(CGRectGetMaxX(self.avatarView.frame) + PROFILE_AVATAR_BUFFER,
                      PROFILE_AVATAR_BUFFER,
                      self.bounds.size.width - CGRectGetMaxX(self.avatarView.frame) - PROFILE_AVATAR_BUFFER,
                      [self totalTextHeight]/4);
}

- (CGRect)networkLabelFrame {
    CGRect labelFrame = self.nameLabel.frame;
    labelFrame.origin.y += ([self totalTextHeight]/4);
    return labelFrame;
}

- (CGRect)emailLabelFrame {
    CGRect labelFrame = self.networkLabel.frame;
    labelFrame.origin.y += ([self totalTextHeight]/4);
    return labelFrame;
}

- (CGRect)phoneNumberLabelFrame {
    CGRect labelFrame = self.emailLabel.frame;
    labelFrame.origin.y += ([self totalTextHeight]/4);
    return labelFrame;
}

- (CGRect)chargeButtonFrame {
    return CGRectMake(PROFILE_AVATAR_BUFFER*2,
                      CGRectGetMaxY(self.avatarView.frame) + PROFILE_AVATAR_BUFFER,
                      self.bounds.size.width/2 - (PROFILE_AVATAR_BUFFER*5)/2,
                      [EVImages grayButtonBackground].size.height);
}

- (CGRect)profileButtonFrame {
    if (self.chargeButton) {
        CGRect frame = self.chargeButton.frame;
        frame.origin.x += frame.size.width + PROFILE_AVATAR_BUFFER;
        return frame;
    }
    return CGRectMake(PROFILE_AVATAR_BUFFER*2,
                      CGRectGetMaxY(self.avatarView.frame) + PROFILE_AVATAR_BUFFER,
                      self.bounds.size.width - PROFILE_AVATAR_BUFFER*4,
                      [EVImages grayButtonBackground].size.height);
}

- (float)totalTextHeight {
    return (PROFILE_AVATAR_LENGTH + PROFILE_EXTRA_TOTAL_LABEL_HEIGHT);
}

@end
