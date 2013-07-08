//
//  EVWalletItemCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletItemCell.h"
#import "EVWalletStamp.h"

@interface EVWalletItemCell ()

@property (nonatomic, strong) UILabel *cashLabel;

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
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [EVFont boldFontOfSize:20.0];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [self.containerView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width / 2.0,
                                                                    0.0,
                                                                    self.containerView.frame.size.width / 2.0 - margin,
                                                                    self.containerView.frame.size.height)];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textColor = [UIColor whiteColor];
        self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        self.valueLabel.font = [EVFont defaultFontOfSize:20.0];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        [self.containerView addSubview:self.valueLabel];
        
        self.cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width / 2.0,
                                                                   0.0,
                                                                   self.containerView.frame.size.width / 2.0 - margin,
                                                                   self.containerView.frame.size.height)];
        self.cashLabel.backgroundColor = [UIColor clearColor];
        self.cashLabel.textColor = [UIColor whiteColor];
        self.cashLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        self.cashLabel.font = [EVFont defaultFontOfSize:20.0];
        self.cashLabel.textAlignment = NSTextAlignmentRight;
        self.cashLabel.text = @"Deposit ➔";
        [self.cashLabel sizeToFit];
    }
    return self;
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
    [self.titleLabel sizeToFit];
    [self.titleLabel setOrigin:CGPointMake(EV_WALLET_CELL_MARGIN,
                                           (self.containerView.frame.size.height - self.titleLabel.frame.size.height) / 2.0)];
    
    [self.valueLabel sizeToFit];
    if (self.isCash)
    {
        [self.containerView addSubview:self.cashLabel];
        [self.cashLabel setOrigin:CGPointMake(self.containerView.frame.size.width - self.cashLabel.frame.size.width - EV_WALLET_CELL_MARGIN,
                                              (self.containerView.frame.size.height - self.cashLabel.frame.size.height) / 2.0)];
        
        
        CGPoint center = self.containerView.center;
        center.x = (CGRectGetMinX(self.cashLabel.frame) + CGRectGetMaxX(self.titleLabel.frame)) / 2.0;
        [self.valueLabel setCenter:center];
    }
    else
    {
        [self.valueLabel setOrigin:CGPointMake(self.containerView.frame.size.width - self.valueLabel.frame.size.width - EV_WALLET_CELL_MARGIN,
                                               (self.containerView.frame.size.height - self.valueLabel.frame.size.height) / 2.0)];
        [self.cashLabel removeFromSuperview];
    }
    
    
    if (self.stamp) {
        [self.stamp setOrigin:CGPointMake(CGRectGetMinX(self.valueLabel.frame) - self.stamp.frame.size.width - EV_WALLET_CELL_MARGIN,
                                          (self.containerView.frame.size.height - self.stamp.frame.size.height) / 2.0)];
        [self.containerView addSubview:self.stamp];
    }
    
}

@end
