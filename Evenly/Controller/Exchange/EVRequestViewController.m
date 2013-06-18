//
//  EVRequestViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController.h"
#import "EVRequestFormView.h"
#import "EVGroupRequestFormView.h"
#import "EVNavigationBarButton.h"
#import "EVPageControl.h"
#import "EVCharge.h"

#define TITLE_PAGE_CONTROL_Y_OFFSET 5.0
#define GROUP_CHARGE_FORM_INFORMATIONAL_LABEL_MARGIN 40.0

@interface EVRequestViewController ()

@property (nonatomic, strong) EVRequestSwitch *requestSwitch;

@property (nonatomic, strong) EVGroupRequestFormView *groupChargeForm;
@property (nonatomic, strong) EVTextField *textField;

@property (nonatomic, strong) EVNavigationBarButton *skipButton;

@property (nonatomic, strong) EVPageControl *pageControl;
@property (nonatomic) CGRect titleLabelFrame;

- (void)loadRequestSwitch;
- (void)loadGroupFormView;
- (void)loadSkipButton;
- (void)loadPageControl;

@end

@implementation EVRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"New Request";
        self.exchange = [EVCharge new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSkipButton];
    [self loadRequestSwitch];
    [self loadGroupFormView];
    [self loadPageControl];
}

- (NSString *)completeExchangeButtonText {
    return @"Request";
}

- (void)loadSkipButton {
    self.skipButton = [[EVNavigationBarButton alloc] initWithTitle:@"Skip"];
    [self.skipButton addTarget:self action:@selector(skipButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    // Position the Skip button correctly for when we need it.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.skipButton];
    // Then switch back to the Request button, which we'll start with.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.completeExchangeButton];
}

- (void)loadFormView {
    self.formView = [[EVRequestFormView alloc] initWithFrame:[self formViewFrame]];
    [self.view addSubview:self.formView];
}

- (void)loadGroupFormView {
    self.groupChargeForm = [[EVGroupRequestFormView alloc] initWithFrame:[self formViewFrame]];
    [self.groupChargeForm setOrigin:CGPointMake(-self.groupChargeForm.frame.size.width, self.groupChargeForm.frame.origin.y)];
    
    CGFloat margin = GROUP_CHARGE_FORM_INFORMATIONAL_LABEL_MARGIN;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin,
                                                               CGRectGetMaxY(self.groupChargeForm.toField.frame),
                                                               self.groupChargeForm.frame.size.width - 2*margin,
                                                               self.groupChargeForm.frame.size.height - CGRectGetMaxY(self.groupChargeForm.toField.frame) - self.requestSwitch.frame.size.height - margin)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [EVFont blackFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [EVColor newsfeedTextColor];
    label.text = @"Add names now or add them later in the dashboard.";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.groupChargeForm addSubview:label];
    
    [self.view insertSubview:self.groupChargeForm belowSubview:self.privacySelector];
}

- (CGRect)formViewFrame {
    CGRect formRect = [super formViewFrame];
    CGSize size = [self requestSwitchSize];
    formRect.origin.y += size.height;
    return formRect;
}

- (CGSize)requestSwitchSize {
    return CGSizeMake(self.view.frame.size.width, 50.0);
}

- (void)loadRequestSwitch {
    UIView *requestSwitchBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               [self requestSwitchSize].width,
                                                                               [self requestSwitchSize].height)];
    requestSwitchBackground.backgroundColor = [EVColor creamColor];
    [self.view addSubview:requestSwitchBackground];
    
    self.requestSwitch = [[EVRequestSwitch alloc] initWithFrame:[self requestSwitchFrame]];
    self.requestSwitch.delegate = self;
    [requestSwitchBackground addSubview:self.requestSwitch];
    
    [RACAble(self.requestSwitch.xPercentage) subscribeNext:^(NSNumber *percentage) {
        [self positionSubviewsForPercentage:[percentage floatValue]];
    }];    
}

- (CGRect)requestSwitchFrame {
    return CGRectMake(10, 7, 300, 35);
}

- (void)loadPageControl {
    self.pageControl = [[EVPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl sizeToFit];
    [self.pageControl setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width / 2.0,
                                            self.titleLabel.frame.size.height + 5.0)];
    [self.navigationController.navigationBar addSubview:self.pageControl];
    self.pageControl.alpha = 0.0f;
    self.titleLabelFrame = self.titleLabel.frame;
}

#pragma mark - Button Actions

- (void)skipButtonPress:(id)sender {
    // TODO: 
}

- (void)positionSubviewsForPercentage:(float)percentage {
    [self.formView setOrigin:CGPointMake(self.view.frame.size.width * percentage,
                                         self.formView.frame.origin.y)];
    CGFloat formWidth = self.groupChargeForm.frame.size.width;
    [self.groupChargeForm setOrigin:CGPointMake(-formWidth + (formWidth * percentage),
                                                self.groupChargeForm.frame.origin.y)];
    
    CGFloat positionAdjustment = (-TITLE_PAGE_CONTROL_Y_OFFSET * percentage);
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:positionAdjustment
                                                                  forBarMetrics:UIBarMetricsDefault];
    CGRect rect = self.titleLabelFrame;
    rect.origin.y += positionAdjustment;
    [self.navigationItem.titleView setFrame:rect];
    [self.pageControl setAlpha:percentage];
}

#pragma mark - EVSwitchDelegate

- (void)switchControl:(EVSwitch *)switchControl willChangeStateTo:(BOOL)onOff animationDuration:(NSTimeInterval)duration {
    if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
            float percentage = (onOff ? 1.0 : 0.0);
            [self positionSubviewsForPercentage:percentage];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(onOff ? self.skipButton : self.completeExchangeButton)];
        }];
    }
}

- (void)switchControl:(EVSwitch *)switchControl didChangeStateTo:(BOOL)onOff {
    if (onOff == NO) {
        [self.formView.toField becomeFirstResponder];
    } else {
        [self.groupChargeForm.toField becomeFirstResponder];
    }
}
@end
