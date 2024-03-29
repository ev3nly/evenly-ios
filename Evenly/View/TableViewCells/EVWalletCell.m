//
//  EVWalletCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletCell.h"

@implementation EVWalletCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.containerView = [[UIView alloc] initWithFrame:[self containerViewFrame]];
//        self.containerView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.containerView.autoresizesSubviews = YES;
        [self.contentView addSubview:self.containerView];

        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WalletArrow"]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.frame = [self containerViewFrame];
}

- (CGRect)containerViewFrame {
    return CGRectMake(EV_RIGHT_OVERHANG_MARGIN,
                      0,
                      self.contentView.frame.size.width - EV_RIGHT_OVERHANG_MARGIN,
                      self.contentView.frame.size.height);
}

@end


@implementation EVWalletSectionHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [EVColor sidePanelHeaderBackgroundColor];
        
        CGFloat margin = 12.0;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(EV_RIGHT_OVERHANG_MARGIN, 0, self.bounds.size.width - EV_RIGHT_OVERHANG_MARGIN, self.bounds.size.height)];
        containerView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        containerView.autoresizesSubviews = YES;
        [self addSubview:containerView];
        self.label = [[EVLabel alloc] initWithFrame:CGRectMake(margin,
                                                               0.0,
                                                               containerView.frame.size.width / 2.0 - margin,
                                                               containerView.frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor sidePanelTextColor];
        self.label.font = [EVFont walletHeaderFont];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        ((EVLabel *)self.label).characterSpacing = 2.0;
        [containerView addSubview:self.label];
    }
    return self;
}

@end
