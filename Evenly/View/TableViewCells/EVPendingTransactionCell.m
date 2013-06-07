//
//  EVPendingTransactionCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingTransactionCell.h"

#define EV_PENDING_TRANSACTION_CELL_MARGIN 10.0

#define EV_PENDING_TRANSACTION_CELL_FONT [EVFont defaultFontOfSize:14]
@implementation EVPendingTransactionCell

+ (CGSize)sizeForTransaction:(EVExchange *)exchange {
    NSString *string = [EVStringUtility stringForExchange:exchange];
    CGFloat margination = EV_RIGHT_OVERHANG_MARGIN + 3*EV_PENDING_TRANSACTION_CELL_MARGIN + [EVAvatarView avatarSize].width;
    CGFloat maxWidth = [UIScreen mainScreen].applicationFrame.size.width - margination;
    CGSize size = [string sizeWithFont:EV_PENDING_TRANSACTION_CELL_FONT
                     constrainedToSize:CGSizeMake(maxWidth, 3*EV_PENDING_TRANSACTION_CELL_FONT.lineHeight)
                         lineBreakMode:NSLineBreakByTruncatingMiddle];
    return CGSizeMake(maxWidth, size.height + 2*EV_PENDING_TRANSACTION_CELL_MARGIN);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGFloat margin = EV_PENDING_TRANSACTION_CELL_MARGIN;
        
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(margin,
                                                                         margin,
                                                                         [EVAvatarView avatarSize].width,
                                                                         [EVAvatarView avatarSize].height)];
        self.avatarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.containerView addSubview:self.avatarView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + margin,
                                                               margin,
                                                               (self.containerView.frame.size.width - CGRectGetMaxX(self.avatarView.frame) - margin), self.containerView.frame.size.height - margin)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 3;
        self.label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.label.font = EV_PENDING_TRANSACTION_CELL_FONT;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.containerView addSubview:self.label];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
