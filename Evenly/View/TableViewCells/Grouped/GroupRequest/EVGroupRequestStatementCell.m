//
//  EVGroupRequestStatementCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestStatementCell.h"
#import "EVGroupRequestStatementLabel.h"
#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"
#import "EVGroupRequest.h"
#import "EVPayment.h"

#define X_MARGIN ([EVUtilities userHasIOS7] ? 20.0 : 10)
#define Y_MARGIN 10.0
#define LINE_HEIGHT 25.0

@interface EVGroupRequestStatementCell ()

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation EVGroupRequestStatementCell

+ (CGFloat)heightForRecord:(EVGroupRequestRecord *)record {
    CGFloat height = LINE_HEIGHT + 2*Y_MARGIN;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lines = [NSMutableArray array];
    }
    return self;
}

- (void)configureForRecord:(EVGroupRequestRecord *)record {
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lines removeAllObjects];

    CGRect frame = CGRectMake(X_MARGIN,
                              0,
                              self.contentView.frame.size.width - 2*X_MARGIN,
                              self.bounds.size.height);

    if (record.numberOfPayments > 0)
    {
        for (EVPayment *payment in record.payments)
        {
            [self loadLabelForPayment:payment frame:frame];
            frame.origin.y += LINE_HEIGHT;
        }
    } else {
        [self loadBalanceLabelForRecord:record frame:frame];
        frame.origin.y += LINE_HEIGHT;
    }
}

- (void)loadLabelForPayment:(EVPayment *)payment frame:(CGRect)frame {
    EVGroupRequestStatementLabel *paymentLabel = nil;
    paymentLabel = [[EVGroupRequestStatementLabel alloc] initWithFrame:frame];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:payment.createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    [paymentLabel.categoryLabel setText:[NSString stringWithFormat:@"Paid %@", dateString]];
    [paymentLabel.amountLabel setText:[EVStringUtility amountStringForAmount:[payment amount]]];
    [paymentLabel.amountLabel setTextColor:[EVColor lightGreenColor]];
    [self.contentView addSubview:paymentLabel];
    [self.lines addObject:paymentLabel];
}

- (void)loadBalanceLabelForRecord:(EVGroupRequestRecord *)record frame:(CGRect)frame {
    EVGroupRequestStatementLabel *balanceLabel = [[EVGroupRequestStatementLabel alloc] initWithFrame:frame];
    [balanceLabel setBold:YES];
    [balanceLabel.categoryLabel setText:@"Owes"];
    NSDecimalNumber *amountOwed = [record amountOwed];
    [balanceLabel.amountLabel setText:[EVStringUtility amountStringForAmount:amountOwed]];
    if (![amountOwed isEqualToNumber:[NSDecimalNumber zero]])
        [balanceLabel.amountLabel setTextColor:[EVColor lightRedColor]];
    [self.contentView addSubview:balanceLabel];
    [self.lines addObject:balanceLabel];
}

@end
