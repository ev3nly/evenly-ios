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
        self.textLabel.font = [EVFont boldFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.highlightedTextColor = [EVColor newsfeedNounColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.textLabel.text = nil;
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
    [self setAccessoryType:(fundingSource.isActive ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
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
    self.textLabel.adjustsLetterSpacingToFitWidth = YES;
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

@end
