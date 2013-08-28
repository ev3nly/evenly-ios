//
//  EVCreditCardCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSourceCell.h"
#import "EVFundingSource.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"


@interface EVFundingSourceCell ()

- (void)setUpWithLastFour:(NSString *)lastFour andBrandImage:(UIImage *)brandImage;
- (void)setUpBrandImage:(UIImage *)brandImage;
- (void)setUpLastFour:(NSString *)lastFour;

- (void)setUpWithAccountNumber:(NSString *)accountNumber andBankName:(NSString *)bankName;

@end

@implementation EVFundingSourceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [EVFont blackFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.highlightedTextColor = [EVColor newsfeedNounColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.frame = [self imageViewFrame];
    self.accessoryView.frame = [self accessoryViewFrame];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.textColor = [EVColor newsfeedNounColor];
}

- (void)setUpWithFundingSource:(EVFundingSource *)fundingSource {
    if ([fundingSource isKindOfClass:[EVCreditCard class]])
    {
        EVCreditCard *card = (EVCreditCard *)fundingSource;
        [self setUpWithLastFour:card.lastFour andBrandImage:card.brandImage];
    }
    else if ([fundingSource isKindOfClass:[EVBankAccount class]])
    {
        EVBankAccount *bankAccount = (EVBankAccount *)fundingSource;
        [self setUpWithAccountNumber:bankAccount.accountNumber andBankName:bankAccount.bankName];
    }
    [self setAccessoryView:(fundingSource.isActive ? [[UIImageView alloc] initWithImage:[EVImages checkIcon]] : nil)];
//    [self setAccessoryType:(fundingSource.isActive ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
}

- (void)setUpWithLastFour:(NSString *)lastFour andBrandImage:(UIImage *)brandImage {
    self.textLabel.textColor = [EVColor newsfeedTextColor];
    [self setUpLastFour:lastFour];
    [self setUpBrandImage:brandImage];
}

- (void)setUpBrandImage:(UIImage *)brandImage {
    self.imageView.image = brandImage;
    if (self.imageView.image == nil)
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)setUpLastFour:(NSString *)lastFour {
    self.textLabel.text = [NSString stringWithFormat:@"**** **** **** %@", lastFour];
    self.textLabel.font = [EVFont defaultFontOfSize:16];
}

- (void)setUpWithAccountNumber:(NSString *)accountNumber andBankName:(NSString *)bankName {
    accountNumber = [accountNumber stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@", bankName, accountNumber];
    self.textLabel.textColor = [EVColor newsfeedTextColor];
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

#pragma mark - Frames

- (CGRect)imageViewFrame {
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = 20;
    return imageFrame;
}

- (CGRect)accessoryViewFrame {
    CGRect accessoryFrame = self.accessoryView.frame;
    accessoryFrame.origin.x = self.bounds.size.width - accessoryFrame.size.width - 20;
    return accessoryFrame;
}

@end

@implementation EVNoFundingSourcesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.illustrationView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.illustrationView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [EVFont blackFontOfSize:15];
        self.label.textColor = [EVColor darkColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
    }
    return self;
}

+ (CGFloat)height {
    return 172.0;
}

- (void)setUpWithIllustration:(UIImage *)illustration text:(NSString *)text {
    self.illustrationView.image = illustration;
    self.label.text = text;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize illustrationSize = self.illustrationView.image.size;
    [self.illustrationView setFrame:CGRectMake((self.contentView.frame.size.width - illustrationSize.width) / 2.0,
                                               20.0,
                                               illustrationSize.width,
                                               illustrationSize.height)];
    [self.label setFrame:CGRectMake(0,
                                    CGRectGetMaxY(self.illustrationView.frame),
                                    self.contentView.frame.size.width,
                                    self.contentView.frame.size.height - CGRectGetMaxY(self.illustrationView.frame))];
    
}

@end

