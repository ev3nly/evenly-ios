//
//  EVWalletItemCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletItemCell.h"
#import "EVWalletStamp.h"

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
    }
    return self;
}


- (void)layoutSubviews {
    [self.titleLabel sizeToFit];
    [self.titleLabel setOrigin:CGPointMake(EV_WALLET_CELL_MARGIN,
                                           (self.containerView.frame.size.height - self.titleLabel.frame.size.height) / 2.0)];
    
    [self.valueLabel sizeToFit];
    [self.valueLabel setOrigin:CGPointMake(self.containerView.frame.size.width - self.valueLabel.frame.size.width - EV_WALLET_CELL_MARGIN,
                                           (self.containerView.frame.size.height - self.valueLabel.frame.size.height) / 2.0)];
    
    if (self.stamp) {
        [self.stamp setOrigin:CGPointMake(CGRectGetMinX(self.valueLabel.frame) - self.stamp.frame.size.width - EV_WALLET_CELL_MARGIN,
                                          (self.containerView.frame.size.height - self.stamp.frame.size.height) / 2.0)];
        [self.containerView addSubview:self.stamp];
    }
    
}

@end
