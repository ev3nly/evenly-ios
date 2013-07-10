//
//  EVWalletItemCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletItemCell.h"
#import "EVWalletStamp.h"

#define STAMP_LEFT_MARGIN 85

@interface EVWalletItemCell ()

@property (nonatomic, strong) UILabel *cashLabel;
@property (nonatomic, strong) UIView *verticalStripe;

@end

@implementation EVWalletItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat margin = EV_WALLET_CELL_MARGIN;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,
                                                                    0.0,
                                                                    self.containerView.frame.size.width / 2.0 - margin,
                                                                    self.containerView.frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [EVColor sidePanelTextColor];
        self.titleLabel.font = [EVFont boldFontOfSize:20.0];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [self.containerView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width / 2.0,
                                                                    0.0,
                                                                    self.containerView.frame.size.width / 2.0 - 2*margin,
                                                                    self.containerView.frame.size.height)];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textColor = [EVColor sidePanelTextColor];
        self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        self.valueLabel.font = [EVFont defaultFontOfSize:15.0];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        [self.containerView addSubview:self.valueLabel];
        
        self.cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width / 2.0,
                                                                   0.0,
                                                                   self.containerView.frame.size.width / 2.0 - margin,
                                                                   self.containerView.frame.size.height)];
        self.cashLabel.backgroundColor = [UIColor clearColor];
        self.cashLabel.textColor = [EVColor blueColor];
        self.cashLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        self.cashLabel.font = [EVFont boldFontOfSize:15];
        self.cashLabel.textAlignment = NSTextAlignmentRight;
        self.cashLabel.text = @"DEPOSIT";
        [self.cashLabel sizeToFit];
        
        self.verticalStripe = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 1, self.frame.size.height)];
        self.verticalStripe.backgroundColor = [EVColor sidePanelStripeColor];
    }
    return self;
}

- (void)setIsCash:(BOOL)isCash {
    _isCash = isCash;
    self.accessoryView = [[UIImageView alloc] initWithImage:( _isCash ? [UIImage imageNamed:@"WalletArrow_blue"] : [UIImage imageNamed:@"WalletArrow"])];
}

- (void)setStamp:(EVWalletStamp *)stamp {
    if (_stamp) {
        [_stamp removeFromSuperview];
        _stamp = nil;
    }
    _stamp = stamp;
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    [self.titleLabel setOrigin:CGPointMake(EV_WALLET_CELL_MARGIN,
                                           (self.containerView.frame.size.height - self.titleLabel.frame.size.height) / 2.0)];
    
    [self.valueLabel sizeToFit];
    if (self.isCash)
    {
        [self.containerView addSubview:self.cashLabel];
        [self.cashLabel setOrigin:CGPointMake(self.containerView.frame.size.width - self.cashLabel.frame.size.width - EV_WALLET_CELL_MARGIN,
                                              (self.containerView.frame.size.height - self.cashLabel.frame.size.height) / 2.0)];
        [self.valueLabel setOrigin:CGPointMake(STAMP_LEFT_MARGIN,
                                               (self.containerView.frame.size.height - self.valueLabel.frame.size.height) / 2.0)];
        [self.containerView addSubview:self.verticalStripe];
    }
    else
    {
        [self.valueLabel setOrigin:CGPointMake(self.containerView.frame.size.width - self.valueLabel.frame.size.width - EV_WALLET_CELL_MARGIN,
                                               (self.containerView.frame.size.height - self.valueLabel.frame.size.height) / 2.0)];
        [self.cashLabel removeFromSuperview];
        [self.verticalStripe removeFromSuperview];
    }
    
    
    if (self.stamp) {
        [self.stamp setOrigin:CGPointMake(STAMP_LEFT_MARGIN,
                                          (self.containerView.frame.size.height - self.stamp.frame.size.height) / 2.0)];
        [self.containerView addSubview:self.stamp];
    }
    
}

@end

@implementation EVWalletHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history"]];
        [iconView setFrame:CGRectMake(self.contentView.frame.size.width - iconView.frame.size.width - EV_WALLET_CELL_MARGIN, (self.contentView.frame.size.height - iconView.frame.size.height) / 2.0, iconView.frame.size.width, iconView.frame.size.height)];
        [iconView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:iconView];
        
        self.titleLabel.text = @"History";
    }
    return self;
}

@end
