//
//  EVGroupRequestPaymentOptionCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPaymentOptionCell.h"

#import "EVGroupRequest.h"
#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"
#import "EVGroupRequestPaymentOptionButton.h"
#import "EVCheckmarkLinkButton.h"

#define TOP_MARGIN 10.0
#define HEADER_LABEL_HEIGHT_WITH_PADDING 40.0
#define SIDE_MARGIN 10

@implementation EVGroupRequestPaymentOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.headerLabel.backgroundColor = [UIColor clearColor];
        self.headerLabel.textColor = [EVColor lightLabelColor];
        [self.headerLabel setFont:[EVFont blackFontOfSize:14]];
        [self.contentView addSubview:self.headerLabel];
        
        self.optionButtons = [NSMutableArray array];
        
        self.position = EVGroupedTableViewCellPositionCenter;
    }
    return self;
}

- (void)setRecord:(EVGroupRequestRecord *)record {
    [self.optionButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.optionButtons removeAllObjects];
    
    if ([record.groupRequest.tiers count] > 1)
    {
        if (record.numberOfPayments > 0)
        {
            EVGroupRequestPaymentOptionButton *button = [EVGroupRequestPaymentOptionButton buttonForTier:record.tier];
            [button setEnabled:NO];
            [button setSelected:YES];
            [self.contentView addSubview:button];
            [self.optionButtons addObject:button];
        } else {
            for (EVGroupRequestTier *tier in record.groupRequest.tiers) {
                EVGroupRequestPaymentOptionButton *button = [EVGroupRequestPaymentOptionButton buttonForTier:tier];
                [self.contentView addSubview:button];
                [self.optionButtons addObject:button];
                button.checked = (record.tier == tier);
                [button setEnabled:YES];
            }
        }
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.headerLabel.text _safeBoundingRectWithSize:CGSizeMake(self.contentView.frame.size.width, FLT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName: self.headerLabel.font}
                                                           context:NULL].size;
    [self.headerLabel setFrame:CGRectMake((self.contentView.frame.size.width - size.width) / 2.0,
                                          TOP_MARGIN,
                                          size.width,
                                          size.height)];
    CGFloat previousY = CGRectGetMaxY(self.headerLabel.frame) + TOP_MARGIN;
    
    for (EVGroupRequestPaymentOptionButton *button in self.optionButtons) {
        button.frame = CGRectMake((self.contentView.frame.size.width - button.frame.size.width) / 2.0,
                                  previousY,
                                  button.frame.size.width,
                                  button.frame.size.height);
        previousY += button.frame.size.height + TOP_MARGIN;
    }
}

- (CGFloat)heightForRecord:(EVGroupRequestRecord *)record {
    if (self.optionButtons.count == 0)
        return 0.0;
    
    [self layoutSubviews];
    CGFloat height = HEADER_LABEL_HEIGHT_WITH_PADDING;
    for (EVGroupRequestPaymentOptionButton *button in self.optionButtons) {
        height += button.frame.size.height + TOP_MARGIN;
    }
    DLog(@"Height for %@: %.1f", record, height);
    return height;
}

@end
