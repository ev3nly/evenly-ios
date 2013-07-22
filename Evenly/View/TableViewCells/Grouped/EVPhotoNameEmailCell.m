//
//  EVPhotoNameNumberCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPhotoNameEmailCell.h"
#import <QuartzCore/QuartzCore.h>

#define SIDE_MARGIN 10
#define AVATAR_LENGTH 88
#define STRIPE_WIDTH 1

@interface EVPhotoNameEmailCell ()

@property (nonatomic, strong) UIView *verticalStripe;
@property (nonatomic, strong) UIView *horizontalStripe;

@end

@implementation EVPhotoNameEmailCell

+ (float)cellHeight {
    return AVATAR_LENGTH + STRIPE_WIDTH;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        [self loadProfilePictureView];
        [self loadVerticalStripe];
        [self loadNameField];
        [self loadHorizontalStripe];
        [self loadEmailField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.profilePictureView.frame = [self profilePictureViewFrame];
    self.verticalStripe.frame = [self verticalStripeFrame];
    self.nameField.frame = [self nameFieldFrame];
    self.horizontalStripe.frame = [self horizontalStripeFrame];
    self.emailField.frame = [self emailFieldFrame];
}

#pragma mark - View Loading

- (void)loadProfilePictureView {
    UIView *clippingContainer = [[UIView alloc] initWithFrame:CGRectMake(SIDE_MARGIN,
                                                                         STRIPE_WIDTH,
                                                                         AVATAR_LENGTH + SIDE_MARGIN,
                                                                         AVATAR_LENGTH + SIDE_MARGIN)];
    clippingContainer.backgroundColor = [UIColor clearColor];
    clippingContainer.layer.cornerRadius = 2.0;
    clippingContainer.clipsToBounds = YES;
    [self addSubview:clippingContainer];
    
    self.profilePictureView = [EVAvatarView new];
    self.profilePictureView.userInteractionEnabled = YES;
    self.profilePictureView.cornerRadius = 0.0;
    self.profilePictureView.image = [EVImages defaultAvatar];
    self.profilePictureView.size = CGSizeMake(AVATAR_LENGTH, AVATAR_LENGTH);
    [clippingContainer addSubview:self.profilePictureView];
}

- (void)loadVerticalStripe {
    self.verticalStripe = [UIView new];
    self.verticalStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.verticalStripe];
}

- (void)loadNameField {
    self.nameField = [UITextField new];
    self.nameField.text = @"";
    self.nameField.textColor = [EVColor darkLabelColor];
    self.nameField.font = [EVFont defaultFontOfSize:16];
    self.nameField.delegate = self;
    self.nameField.textAlignment = NSTextAlignmentLeft;
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.placeholder = @"Name";
    [self addSubview:self.nameField];
}

- (void)loadHorizontalStripe {
    self.horizontalStripe = [UIView new];
    self.horizontalStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.horizontalStripe];
}

- (void)loadEmailField {
    self.emailField = [UITextField new];
    self.emailField.text = @"";
    self.emailField.textAlignment = NSTextAlignmentLeft;
    self.emailField.textColor = [EVColor darkLabelColor];
    self.emailField.font = [EVFont defaultFontOfSize:16];
    self.emailField.delegate = self;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.placeholder = @"Email";
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:self.emailField];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameField)
        [self.emailField becomeFirstResponder];
    else {
        if (self.handleEnteredEmail)
            self.handleEnteredEmail();
    }
    return YES;
}

#pragma mark - Setters

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    
    self.profilePictureView.image = photo;
}

#pragma mark - Frames

- (CGRect)profilePictureViewFrame {
    return CGRectMake(0,
                      0,
                      AVATAR_LENGTH,
                      AVATAR_LENGTH);
}

- (CGRect)verticalStripeFrame {
    return CGRectMake(CGRectGetMaxX(self.profilePictureView.frame) + SIDE_MARGIN,
                      0,
                      STRIPE_WIDTH,
                      self.bounds.size.height);
}

- (CGRect)nameFieldFrame {
    [self.nameField sizeToFit];
    return CGRectMake(CGRectGetMaxX(self.verticalStripe.frame) + SIDE_MARGIN,
                      self.bounds.size.height/4 - self.nameField.bounds.size.height/2,
                      self.bounds.size.width - CGRectGetMaxX(self.verticalStripe.frame) - SIDE_MARGIN,
                      self.nameField.bounds.size.height);
}

- (CGRect)horizontalStripeFrame {
    return CGRectMake(CGRectGetMaxX(self.verticalStripe.frame),
                      self.bounds.size.height/2 - STRIPE_WIDTH,
                      self.nameField.frame.size.width,
                      STRIPE_WIDTH);
}

- (CGRect)emailFieldFrame {
    return CGRectMake(self.nameField.frame.origin.x,
                      CGRectGetMaxY(self.horizontalStripe.frame) + self.bounds.size.height/4 - self.nameField.bounds.size.height/2,
                      self.nameField.frame.size.width,
                      self.nameField.bounds.size.height);
}

@end
