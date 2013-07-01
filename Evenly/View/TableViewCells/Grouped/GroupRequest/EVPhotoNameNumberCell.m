//
//  EVPhotoNameNumberCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPhotoNameNumberCell.h"

#define AVATAR_LENGTH 80

@interface EVPhotoNameNumberCell ()

@property (nonatomic, strong) UIView *verticalStripe;
@property (nonatomic, strong) UIView *horizontalStripe;

@end

@implementation EVPhotoNameNumberCell

+ (float)cellHeight {
    return AVATAR_LENGTH;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadProfilePictureView];
        [self loadVerticalStripe];
        [self loadNameField];
        [self loadHorizontalStripe];
        [self loadPhoneNumberField];
        [self configureReactions];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.profilePictureView.frame = [self profilePictureViewFrame];
    self.verticalStripe.frame = [self verticalStripeFrame];
    self.nameField.frame = [self nameFieldFrame];
    self.horizontalStripe.frame = [self horizontalStripeFrame];
    self.phoneNumberField.frame = [self phoneNumberFieldFrame];
}

#pragma mark - View Loading

- (void)loadProfilePictureView {
    self.profilePictureView = [[UIImageView alloc] initWithImage:[EVImages defaultAvatar]];
    [self addSubview:self.profilePictureView];
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

- (void)loadPhoneNumberField {
    self.phoneNumberField = [UITextField new];
    self.phoneNumberField.text = @"";
    self.phoneNumberField.textAlignment = NSTextAlignmentLeft;
    self.phoneNumberField.textColor = [EVColor darkLabelColor];
    self.phoneNumberField.font = [EVFont defaultFontOfSize:16];
    self.phoneNumberField.delegate = self;
    self.phoneNumberField.returnKeyType = UIReturnKeyNext;
    self.phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.phoneNumberField];
}

- (void)configureReactions {
    [self.phoneNumberField.rac_textSignal subscribeNext:^(NSString *text) {
        text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (text.length > 10)
            text = [text substringToIndex:10];
        if (text.length > 6) {
            NSString *firstThree = [text substringWithRange:NSMakeRange(0, 3)];
            NSString *nextThree = [text substringWithRange:NSMakeRange(3, 3)];
            NSString *rest = [text substringFromIndex:6];
            text = [NSString stringWithFormat:@"%@-%@-%@", firstThree, nextThree, rest];
        } else if (text.length > 3) {
            NSString *firstThree = [text substringWithRange:NSMakeRange(0, 3)];
            NSString *rest = [text substringFromIndex:3];
            text = [NSString stringWithFormat:@"%@-%@", firstThree, rest];
        }
        self.phoneNumberField.text = text;
    }];
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
    return CGRectMake(CGRectGetMaxX(self.profilePictureView.frame),
                      0,
                      1,
                      self.bounds.size.height);
}

- (CGRect)nameFieldFrame {
    return CGRectMake(CGRectGetMaxX(self.verticalStripe.frame),
                      0,
                      self.bounds.size.width - CGRectGetMaxX(self.verticalStripe.frame),
                      self.bounds.size.height/2);
}

- (CGRect)horizontalStripeFrame {
    return CGRectMake(CGRectGetMaxX(self.verticalStripe.frame),
                      self.bounds.size.height/2 - 1,
                      self.bounds.size.width - CGRectGetMaxX(self.verticalStripe.frame),
                      1);
}

- (CGRect)phoneNumberFieldFrame {
    return CGRectMake(self.nameField.frame.origin.x,
                      CGRectGetMaxY(self.horizontalStripe.frame),
                      self.nameField.frame.size.width,
                      self.bounds.size.height/2);
}

@end
