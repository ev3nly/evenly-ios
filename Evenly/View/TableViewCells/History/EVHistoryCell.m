//
//  EVHistoryCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryCell.h"

#define LEFT_TEXT_BUFFER 20
#define TOP_TEXT_BUFFER 10
#define TITLE_SUBTITLE_BUFFER 0

#define TITLE_FONT_SIZE 14
#define SUBTITLE_FONT_SIZE 14
#define AMOUNT_FONT_SIZE 14

#define TITLE_FONT [EVFont blackFontOfSize:TITLE_FONT_SIZE]
#define SUBTITLE_FONT [EVFont defaultFontOfSize:SUBTITLE_FONT_SIZE]

@interface EVHistoryCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *amountLabel;

- (void)configureTitleLabel;
- (void)loadSubtitleLabel;
- (void)loadAmountLabel;

- (CGRect)titleLabelFrame;
- (CGRect)subtitleLabelFrame;
- (CGRect)amountLabelFrame;

- (float)heightForTitleAndSubtitle;
- (float)heightForSubtitle;

@end

@implementation EVHistoryCell

+ (float)heightGivenSubtitle:(NSString *)subtitle {
    float maxWidth = [UIScreen mainScreen].applicationFrame.size.width - LEFT_TEXT_BUFFER*2;
    CGSize subtitleSize = [subtitle boundingRectWithSize:CGSizeMake(maxWidth, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: SUBTITLE_FONT}
                                                 context:NULL].size;
    CGSize titleSize = [@"title" boundingRectWithSize:CGSizeMake(maxWidth, 50)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: TITLE_FONT}
                                              context:NULL].size;
    float totalHeight = (TOP_TEXT_BUFFER + titleSize.height + TITLE_SUBTITLE_BUFFER + subtitleSize.height + TOP_TEXT_BUFFER);
    if ((int)totalHeight%2 != 0)
        totalHeight++;
    return floorf(totalHeight);
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.text = @"";
        [self configureTitleLabel];
        [self loadSubtitleLabel];
        [self loadAmountLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.subtitleLabel sizeToFit];
    [self.amountLabel sizeToFit];
    
    self.titleLabel.frame = [self titleLabelFrame];
    self.subtitleLabel.frame = [self subtitleLabelFrame];
    self.amountLabel.frame = [self amountLabelFrame];
}

#pragma mark - View Setup

- (void)configureTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [EVColor newsfeedNounColor];
    self.titleLabel.font = TITLE_FONT;
    [self addSubview:self.titleLabel];
}

- (void)loadSubtitleLabel {
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.textColor = [EVColor newsfeedTextColor];
    self.subtitleLabel.font = SUBTITLE_FONT;
    self.subtitleLabel.numberOfLines = 0;
    [self addSubview:self.subtitleLabel];
}

- (void)loadAmountLabel {
    self.amountLabel = [UILabel new];
    self.amountLabel.backgroundColor = [UIColor clearColor];
    self.amountLabel.textAlignment = NSTextAlignmentRight;
    self.amountLabel.font = [EVFont boldFontOfSize:AMOUNT_FONT_SIZE];
    [self addSubview:self.amountLabel];
}

#pragma mark - Set Values

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle amount:(NSDecimalNumber *)amount {
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
    
    NSString *currencyString = [EVStringUtility amountStringForAmount:amount];
    if ([currencyString rangeOfString:@"("].location != NSNotFound) {
        currencyString = [currencyString stringByReplacingOccurrencesOfString:@"(" withString:@"-"];
        currencyString = [currencyString stringByReplacingOccurrencesOfString:@")" withString:@""];
    } else {
        currencyString = [@"+" stringByAppendingString:currencyString];
    }
    
    self.amountLabel.text = currencyString;
    self.amountLabel.textColor = ([amount floatValue] > 0) ? [EVColor lightGreenColor] : [EVColor lightRedColor];
    
    [self setNeedsLayout];
}

#pragma mark - View Defines

- (CGRect)titleLabelFrame {
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = LEFT_TEXT_BUFFER;
    titleFrame.origin.y = self.bounds.size.height/2 - [self heightForTitleAndSubtitle]/2;
    return titleFrame;
}

- (CGRect)subtitleLabelFrame {
    return CGRectMake(LEFT_TEXT_BUFFER,
                      CGRectGetMaxY(self.titleLabel.frame) + TITLE_SUBTITLE_BUFFER,
                      self.bounds.size.width - LEFT_TEXT_BUFFER*2,
                      [self heightForSubtitle]);
}

- (CGRect)amountLabelFrame {
    CGRect amountFrame = self.amountLabel.frame;
    amountFrame.origin.x = self.bounds.size.width - LEFT_TEXT_BUFFER - self.amountLabel.bounds.size.width;
    amountFrame.origin.y = self.titleLabel.frame.origin.y;
    return amountFrame;
}

#pragma mark - Utility

- (float)heightForTitleAndSubtitle {
    return (self.titleLabel.bounds.size.height + [self heightForSubtitle] + TITLE_SUBTITLE_BUFFER);
}

- (float)heightForSubtitle {
    return [self.subtitleLabel multiLineSizeForWidth:self.bounds.size.width - LEFT_TEXT_BUFFER*2].height;
}

@end
