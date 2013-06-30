//
//  EVPartialPaymentViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPartialPaymentViewController.h"
#import "EVNavigationBarButton.h"
#import "EVRequestBigAmountView.h"
#import "EVGroupRequest.h"

#define TOP_MARGIN 6
#define LEFT_RIGHT_MARGIN 10.0
#define LABEL_HEIGHT 25

@interface EVPartialPaymentViewController ()

@property (nonatomic, strong) UILabel *youOweLabel;
@property (nonatomic, strong) UILabel *howMuchToPayLabel;
@property (nonatomic, strong) EVNavigationBarButton *payButton;
@property (nonatomic, strong) EVRequestBigAmountView *bigAmountView;

- (void)loadYouOweLabel;
- (void)loadHowMuchToPayLabel;
- (void)loadBigAmountView;

@end

@implementation EVPartialPaymentViewController

- (id)initWithRecord:(EVGroupRequestRecord *)record {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.record = record;
        
        self.payButton = [[EVNavigationBarButton alloc] initWithTitle:@"Pay"];
        [self.payButton addTarget:self action:@selector(payButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.payButton];
        
        self.title = @"Partial Payment";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadYouOweLabel];
    [self loadHowMuchToPayLabel];
    [self loadBigAmountView];
    [self setUpReactions];
}

- (void)loadYouOweLabel {
    self.youOweLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_RIGHT_MARGIN,
                                                                TOP_MARGIN,
                                                                self.view.frame.size.width - 2*LEFT_RIGHT_MARGIN,
                                                                LABEL_HEIGHT)];
    self.youOweLabel.font = [EVFont blackFontOfSize:18];
    self.youOweLabel.textAlignment = NSTextAlignmentCenter;
    self.youOweLabel.textColor = [UIColor blackColor];
    self.youOweLabel.backgroundColor = [UIColor clearColor];
    self.youOweLabel.adjustsLetterSpacingToFitWidth = YES;
    self.youOweLabel.adjustsFontSizeToFitWidth = YES;
    self.youOweLabel.minimumScaleFactor = 0.6;
    self.youOweLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.youOweLabel.text = [NSString stringWithFormat:@"You owe %@.", [EVStringUtility amountStringForAmount:self.record.amountOwed]];
    [self.view addSubview:self.youOweLabel];
}

- (void)loadHowMuchToPayLabel {
    self.howMuchToPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_RIGHT_MARGIN,
                                                                 CGRectGetMaxY(self.youOweLabel.frame),
                                                                 self.view.frame.size.width - 2*LEFT_RIGHT_MARGIN,
                                                                 LABEL_HEIGHT)];
    self.howMuchToPayLabel.font = [EVFont blackFontOfSize:18];
    self.howMuchToPayLabel.textAlignment = NSTextAlignmentCenter;
    self.howMuchToPayLabel.textColor = [UIColor blackColor];
    self.howMuchToPayLabel.backgroundColor = [UIColor clearColor];
    self.howMuchToPayLabel.adjustsLetterSpacingToFitWidth = YES;
    self.howMuchToPayLabel.adjustsFontSizeToFitWidth = YES;
    self.howMuchToPayLabel.minimumScaleFactor = 0.6;
    self.howMuchToPayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.howMuchToPayLabel.text = [NSString stringWithFormat:@"How much do you want to pay?"];
    [self.view addSubview:self.howMuchToPayLabel];
}

- (void)loadBigAmountView {
    self.bigAmountView = [[EVRequestBigAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.howMuchToPayLabel.frame), self.view.frame.size.width, [EVRequestBigAmountView totalHeight])];
    [self.view addSubview:self.bigAmountView];
}

- (void)setUpReactions {
    [self.bigAmountView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        float amount = [[EVStringUtility amountFromAmountString:self.bigAmountView.amountField.text] floatValue];
        BOOL okay = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT && amount <= [self.record.amountOwed floatValue]);
        [self.navigationItem.rightBarButtonItem setEnabled:okay];
        [self.bigAmountView.minimumAmountLabel setHidden:okay];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bigAmountView becomeFirstResponder];
}

- (void)payButtonPress:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"PAYING..."];
    NSDecimalNumber *amount = [EVStringUtility amountFromAmountString:self.bigAmountView.amountField.text];
    [self.record.groupRequest makePaymentOfAmount:amount
                                        forRecord:self.record
                                      withSuccess:^(EVPayment *payment) {
                                        if (self.delegate)
                                            [self.delegate viewController:self madePartialPayment:payment];
                                          [[EVStatusBarManager sharedManager] setPostSuccess:^{
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }];
                                           [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                                      } failure:^(NSError *error) {
                                          [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                                          self.navigationItem.leftBarButtonItem.enabled = YES;
                                          self.navigationItem.rightBarButtonItem.enabled = YES;
                                      }];
}

@end
