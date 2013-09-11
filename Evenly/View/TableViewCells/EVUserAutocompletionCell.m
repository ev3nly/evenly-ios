//
//  EVUserAutocompletionCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVUserAutocompletionCell.h"

#define LABEL_FONT_SIZE 14

#define LEFT_BUFFER 5
#define TOP_BUFFER 3

#define NAME_LABEL_Y_OFFSET 5
#define EMAIL_LABEL_Y_OFFSET 2
#define STRIPE_HEIGHT [EVUtilities scaledDividerHeight]

@interface EVUserAutocompletionCell ()

- (void)loadNameLabel;
- (void)loadEmailLabel;
- (void)loadStripe;

- (CGRect)nameLabelFrame;
- (CGRect)emailLabelFrame;
- (CGRect)stripeFrame;

@end

@implementation EVUserAutocompletionCell

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        [self loadNameLabel];
        [self loadEmailLabel];
//        [self loadStripe];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadNameLabel
{
    self.nameLabel = [[UILabel alloc] initWithFrame:[self nameLabelFrame]];
    self.nameLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT | UIViewAutoresizingFlexibleBottomMargin;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:LABEL_FONT_SIZE];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.nameLabel align];
    [self.contentView addSubview:self.nameLabel];
}

- (void)loadEmailLabel
{
    self.emailLabel = [[UILabel alloc] initWithFrame:[self emailLabelFrame]];
    self.emailLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.emailLabel.backgroundColor = [UIColor clearColor];
    self.emailLabel.textColor = [EVColor lightLabelColor];
    self.emailLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    self.emailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.emailLabel align];
    [self.contentView addSubview:self.emailLabel];
}

- (void)loadStripe
{
    self.stripe = [[UIView alloc] initWithFrame:[self stripeFrame]];
    self.stripe.backgroundColor = [EVColor newsfeedStripeColor];
    self.stripe.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.stripe];
}

#pragma mark - Frame Defines

- (CGRect)nameLabelFrame {
    return CGRectMake(LEFT_BUFFER,
                      TOP_BUFFER,
                      self.contentView.frame.size.width - LEFT_BUFFER,
                      self.contentView.frame.size.height / 2.0 - NAME_LABEL_Y_OFFSET);
}

- (CGRect)emailLabelFrame {
    return CGRectMake(LEFT_BUFFER,
                      self.contentView.frame.size.height / 2.0,
                      self.contentView.frame.size.width - LEFT_BUFFER,
                      self.contentView.frame.size.height / 2.0 - EMAIL_LABEL_Y_OFFSET);
}

- (CGRect)stripeFrame {
    return CGRectMake(0,
                      self.frame.size.height - STRIPE_HEIGHT,
                      self.frame.size.width,
                      STRIPE_HEIGHT);
}

@end
