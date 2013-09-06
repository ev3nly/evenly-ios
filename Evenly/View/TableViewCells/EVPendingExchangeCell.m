//
//  EVPendingExchangeCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingExchangeCell.h"

#import "EVExchange.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"
#import "EVWalletNotification.h"

#define EV_PENDING_EXCHANGE_CELL_MARGIN 10.0
#define EV_PENDING_EXCHANGE_CELL_Y_MARGIN 5.0
#define EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH 185.0
#define EV_PENDING_EXCHANGE_CELL_AMOUNT_LABEL_Y_OFFSET 1

#define EV_PENDING_EXCHANGE_CELL_FONT [EVFont defaultFontOfSize:14]
#define EV_PENDING_EXCHANGE_CELL_BOLD_FONT [EVFont boldFontOfSize:14]

#define MIN_LABEL_SPACING 3


@interface EVPendingExchangeCell ()

@property (nonatomic, strong) UIView *exchangeContainer;
@property (nonatomic, strong) EVLabel *descriptionLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIView *groupRequestContainer;
@property (nonatomic, strong) UILabel *groupRequestLabel;

@end

@implementation EVPendingExchangeCell

+ (CGSize)sizeForInteraction:(EVObject *)object {
    NSString *string = [EVStringUtility stringForInteraction:object];
    CGFloat maxWidth = EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH;
    CGSize size = [string _safeBoundingRectWithSize:CGSizeMake(maxWidth, 3*EV_PENDING_EXCHANGE_CELL_FONT.lineHeight)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: EV_PENDING_EXCHANGE_CELL_FONT}
                                            context:NULL].size;
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
        
        [self loadExchangeViews];
        [self loadGroupRequestViews];
        
    }
    return self;
}

- (void)loadExchangeViews {
    self.exchangeContainer = [[UIView alloc] initWithFrame:[self containerFrame]];
    
    self.descriptionLabel = [[EVLabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.exchangeContainer addSubview:self.descriptionLabel];
    
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.font = EV_PENDING_EXCHANGE_CELL_BOLD_FONT;
    self.amountLabel.backgroundColor = [UIColor clearColor];
    
    [self.exchangeContainer addSubview:self.amountLabel];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dateLabel.font = EV_PENDING_EXCHANGE_CELL_FONT;
    self.dateLabel.backgroundColor = [UIColor clearColor];
    [self.exchangeContainer addSubview:self.dateLabel];
}

- (void)loadGroupRequestViews {
    self.groupRequestContainer = [[UIView alloc] initWithFrame:[self containerFrame]];
    //    self.groupRequestContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    self.groupRequestLabel = [[UILabel alloc] initWithFrame:self.groupRequestContainer.bounds];
    self.groupRequestLabel.backgroundColor = [UIColor clearColor];
    self.groupRequestLabel.textColor = [EVColor sidePanelTextColor];
    self.groupRequestLabel.numberOfLines = 3;
    self.groupRequestLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.groupRequestLabel.font = EV_PENDING_EXCHANGE_CELL_FONT;
    self.groupRequestLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self.groupRequestContainer addSubview:self.groupRequestLabel];
}

- (void)configureForInteraction:(EVObject *)object {
    if ([object isKindOfClass:[EVExchange class]]) {
        [self configureForExchange:(EVExchange *)object];
    } else if ([object isKindOfClass:[EVGroupRequest class]]) {
        [self configureForGroupRequest:(EVGroupRequest *)object];
    } else if ([object isKindOfClass:[EVWalletNotification class]]) {
        [self configureForWalletNotification:(EVWalletNotification *)object];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)configureForExchange:(EVExchange *)exchange {
    [self.groupRequestContainer removeFromSuperview];
    
    [self.exchangeContainer setFrame:[self containerFrame]];
    NSAttributedString *descriptionString = [EVStringUtility attributedStringForPendingExchange:exchange];
    NSString *amountString = [EVStringUtility amountStringForAmount:exchange.amount];
    NSString *dateString = [[EVStringUtility shortDateFormatter] stringFromDate:exchange.createdAt];
    
    self.amountLabel.text = amountString;
    [self.amountLabel sizeToFit];
    CGFloat yMidpoint = self.exchangeContainer.frame.size.height / 2.0;
    
    [self.amountLabel setFrame:CGRectMake(self.exchangeContainer.frame.size.width - self.amountLabel.frame.size.width,
                                          yMidpoint - self.amountLabel.frame.size.height/2 + EV_PENDING_EXCHANGE_CELL_AMOUNT_LABEL_Y_OFFSET,
                                          self.amountLabel.frame.size.width,
                                          self.amountLabel.frame.size.height)];
    self.amountLabel.textColor = (exchange.from == nil) ? [EVColor lightGreenColor] : [EVColor lightRedColor];
    
    [self.descriptionLabel setAttributedText:descriptionString];
    [self.descriptionLabel setFrame:CGRectMake(0,
                                               yMidpoint - self.amountLabel.frame.size.height,
                                               CGRectGetMinX(self.amountLabel.frame) - MIN_LABEL_SPACING,
                                               self.amountLabel.frame.size.height)];
    [self.descriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.descriptionLabel setAdjustLetterSpacingToFitWidth:YES];
    [self.descriptionLabel setNumberOfLines:1];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self.dateLabel setText:dateString];
    [self.dateLabel sizeToFit];
    [self.dateLabel setFrame:CGRectMake(0,
                                        CGRectGetMaxY(self.descriptionLabel.frame),
                                        self.dateLabel.frame.size.width,
                                        self.dateLabel.frame.size.height)];
    [self.containerView addSubview:self.exchangeContainer];
}

- (void)configureForGroupRequest:(EVGroupRequest *)groupRequest {
    [self.groupRequestContainer removeFromSuperview];
    
    [self.exchangeContainer setFrame:[self containerFrame]];
    NSAttributedString *descriptionString = [EVStringUtility attributedStringForGroupRequest:groupRequest];
    NSString *amountString = nil;
    if (groupRequest.tiers.count == 1)
        amountString = [EVStringUtility amountStringForAmount:[[[groupRequest tiers] objectAtIndex:0] price]];
    else if ([groupRequest myRecord] && [[groupRequest myRecord] tier])
        amountString = [EVStringUtility amountStringForAmount:[[[groupRequest myRecord] tier] price]];
    else
        amountString = @"TBD";
    
    NSString *dateString = [[EVStringUtility shortDateFormatter] stringFromDate:groupRequest.createdAt];
    
    self.amountLabel.text = amountString;
    [self.amountLabel sizeToFit];
    CGFloat yMidpoint = self.exchangeContainer.frame.size.height / 2.0;
    
    [self.amountLabel setFrame:CGRectMake(self.exchangeContainer.frame.size.width - self.amountLabel.frame.size.width,
                                          yMidpoint - self.amountLabel.frame.size.height/2 + EV_PENDING_EXCHANGE_CELL_AMOUNT_LABEL_Y_OFFSET,
                                          self.amountLabel.frame.size.width,
                                          self.amountLabel.frame.size.height)];
    self.amountLabel.textColor = (groupRequest.from == nil) ? [EVColor lightGreenColor] : [EVColor lightRedColor];
    
    [self.descriptionLabel setAttributedText:descriptionString];
    [self.descriptionLabel setFrame:CGRectMake(0,
                                               yMidpoint - self.amountLabel.frame.size.height,
                                               CGRectGetMinX(self.amountLabel.frame) - MIN_LABEL_SPACING,
                                               self.amountLabel.frame.size.height)];
    [self.descriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.descriptionLabel setAdjustLetterSpacingToFitWidth:YES];
    [self.descriptionLabel setNumberOfLines:1];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self.dateLabel setText:dateString];
    [self.dateLabel sizeToFit];
    [self.dateLabel setFrame:CGRectMake(0,
                                        CGRectGetMaxY(self.descriptionLabel.frame),
                                        self.dateLabel.frame.size.width,
                                        self.dateLabel.frame.size.height)];
    [self.containerView addSubview:self.exchangeContainer];
}

- (void)configureForWalletNotification:(EVWalletNotification *)walletNotification {
    [self.exchangeContainer removeFromSuperview];
    [self.groupRequestLabel setText:walletNotification.headline];
    
    [self.groupRequestContainer setFrame:[self containerFrame]];
    [self.containerView addSubview:self.groupRequestContainer];
}

- (CGRect)containerFrame {
    return CGRectMake(CGRectGetMaxX(self.avatarView.frame) + EV_PENDING_EXCHANGE_CELL_MARGIN,
                      EV_PENDING_EXCHANGE_CELL_Y_MARGIN,
                      EV_PENDING_EXCHANGE_CELL_MAX_LABEL_WIDTH,
                      self.frame.size.height - 2*EV_PENDING_EXCHANGE_CELL_Y_MARGIN);
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
        self.groupRequestLabel.font = [EVFont blackFontOfSize:14];
        self.groupRequestLabel.textAlignment = NSTextAlignmentCenter;
        self.groupRequestLabel.numberOfLines = 1;
        self.groupRequestLabel.text = @"Congrats!  You're all settled up!";
        self.groupRequestLabel.frame = self.containerView.bounds;
        
        [self.containerView addSubview:self.groupRequestLabel];
        
        [self.avatarView removeFromSuperview];
        self.avatarView = nil;
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.stripe removeFromSuperview];
        self.stripe = nil;
    }
    return self;
}
@end
