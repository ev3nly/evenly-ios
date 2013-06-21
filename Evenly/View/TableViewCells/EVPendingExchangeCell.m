//
//  EVPendingExchangeCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingExchangeCell.h"

#define EV_PENDING_EXCHANGE_CELL_MARGIN 10.0
#define EV_PENDING_EXCHANGE_CELL_Y_MARGIN 5.0
#define EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH 190.0

#define EV_PENDING_EXCHANGE_CELL_FONT [EVFont defaultFontOfSize:14]
@implementation EVPendingExchangeCell

+ (CGSize)sizeForInteraction:(EVObject *)object {
    NSString *string = [EVStringUtility stringForInteraction:object];
//    CGFloat margination = EV_RIGHT_OVERHANG_MARGIN + 4*EV_PENDING_EXCHANGE_CELL_MARGIN + [EVAvatarView avatarSize].width;
    CGFloat maxWidth = EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH;
    CGSize size = [string sizeWithFont:EV_PENDING_EXCHANGE_CELL_FONT
                     constrainedToSize:CGSizeMake(maxWidth, 3*EV_PENDING_EXCHANGE_CELL_FONT.lineHeight)
                         lineBreakMode:NSLineBreakByTruncatingMiddle];
    
    CGFloat height = MAX(size.height + 2*EV_PENDING_EXCHANGE_CELL_Y_MARGIN, [EVAvatarView avatarSize].height + 2*EV_PENDING_EXCHANGE_CELL_MARGIN);
    return CGSizeMake(EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH, height);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGFloat margin = EV_PENDING_EXCHANGE_CELL_MARGIN;
        
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(margin,
                                                                         margin,
                                                                         [EVAvatarView avatarSize].width,
                                                                         [EVAvatarView avatarSize].height)];
        self.avatarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.containerView addSubview:self.avatarView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + margin,
                                                               EV_PENDING_EXCHANGE_CELL_Y_MARGIN,
                                                               EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH,
                                                               self.containerView.frame.size.height - 2*EV_PENDING_EXCHANGE_CELL_Y_MARGIN)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 3;
        self.label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.label.font = EV_PENDING_EXCHANGE_CELL_FONT;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
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

@implementation EVNoPendingExchangesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label.font = [EVFont boldFontOfSize:14];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 1;
        self.label.text = @"No pending transactions";
        self.label.frame = self.containerView.bounds;
        [self.avatarView removeFromSuperview];
        self.avatarView = nil;
        self.accessoryView = nil;        
    }
    return self;
}
@end
