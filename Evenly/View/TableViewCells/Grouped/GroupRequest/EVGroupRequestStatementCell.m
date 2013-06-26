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
#import "EVPayment.h"

#define X_MARGIN 10.0
#define Y_MARGIN 10.0
#define LINE_HEIGHT 25.0

@interface EVGroupRequestStatementCell ()

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation EVGroupRequestStatementCell

+ (CGFloat)heightForRecord:(EVGroupRequestRecord *)record {
    int numberOfRows = 2 + record.numberOfPayments;
    CGFloat height = numberOfRows * LINE_HEIGHT + 2*Y_MARGIN;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lines = [NSMutableArray array];
        self.position = EVGroupedTableViewCellPositionCenter;
    }
    return self;
}

- (void)configureForRecord:(EVGroupRequestRecord *)record {
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lines removeAllObjects];
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = nil;
    
    CGRect frame = CGRectMake(X_MARGIN,
                              Y_MARGIN,
                              self.contentView.frame.size.width - 2*X_MARGIN,
                              LINE_HEIGHT);
    [self loadHeaderLabelForRecord:record frame:frame];
    frame.origin.y += LINE_HEIGHT;
    
    if (record.payments.count != [record numberOfPayments])
    {
        CGFloat step = [self loadActivityIndicatorForRecord:record frame:frame];
        frame.origin.y +=step;
    }
    else if (record.numberOfPayments > 0)
    {
        for (EVPayment *payment in record.payments)
        {
            [self loadLabelForPayment:payment frame:frame];
            frame.origin.y += LINE_HEIGHT;
        }
    }
    
    [self loadBalanceLabelForRecord:record frame:frame];
    frame.origin.y += LINE_HEIGHT;
}

- (void)loadHeaderLabelForRecord:(EVGroupRequestRecord *)record frame:(CGRect)frame {
    EVGroupRequestStatementLabel *headerLabel = [[EVGroupRequestStatementLabel alloc] initWithFrame:frame];
    [headerLabel setBold:YES];
    [headerLabel.categoryLabel setText:[record.tier name]];
    [headerLabel.amountLabel setText:[EVStringUtility amountStringForAmount:[record.tier price]]];
    [self.contentView addSubview:headerLabel];
    [self.lines addObject:headerLabel];
}

- (CGFloat)loadActivityIndicatorForRecord:(EVGroupRequestRecord *)record frame:(CGRect)frame {
    CGFloat step = LINE_HEIGHT * [record numberOfPayments];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(frame), frame.origin.y + step / 2.0);
    self.activityIndicator.autoresizingMask = EV_AUTORESIZE_TO_CENTER;
    [self.contentView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    return step;
}

- (void)loadLabelForPayment:(EVPayment *)payment frame:(CGRect)frame {
    EVGroupRequestStatementLabel *paymentLabel = nil;
    paymentLabel = [[EVGroupRequestStatementLabel alloc] initWithFrame:frame];
    [paymentLabel setIndented:YES];
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
    [balanceLabel setIndented:YES];
    [balanceLabel.categoryLabel setText:@"Balance"];
    NSDecimalNumber *amountOwed = [record amountOwed];
    [balanceLabel.amountLabel setText:[EVStringUtility amountStringForAmount:amountOwed]];
    if (![amountOwed isEqualToNumber:[NSDecimalNumber zero]])
        [balanceLabel.amountLabel setTextColor:[EVColor lightRedColor]];
    [self.contentView addSubview:balanceLabel];
    [self.lines addObject:balanceLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
