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



@property (nonatomic, strong) EVPageControl *pageControl;
@property (nonatomic) CGRect titleLabelFrame;

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
    
}

- (NSString *)completeExchangeButtonText {
    return @"Request";
}

- (void)loadFormView {
    self.formView = [[EVRequestFormView alloc] initWithFrame:[self formViewFrame]];
    [self.view addSubview:self.formView];
}

- (CGRect)formViewFrame {
    CGRect formRect = [super formViewFrame];
    return formRect;
}

- (void)loadPrivacySelector {
    // override to no-op
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

//- (void)positionSubviewsForPercentage:(float)percentage {
//    [self.formView setOrigin:CGPointMake(self.view.frame.size.width * percentage,
//                                         self.formView.frame.origin.y)];
//    CGFloat formWidth = self.groupChargeForm.frame.size.width;
//    [self.groupChargeForm setOrigin:CGPointMake(-formWidth + (formWidth * percentage),
//                                                self.groupChargeForm.frame.origin.y)];
//    
//    CGFloat positionAdjustment = (-TITLE_PAGE_CONTROL_Y_OFFSET * percentage);
//    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:positionAdjustment
//                                                                  forBarMetrics:UIBarMetricsDefault];
//    CGRect rect = self.titleLabelFrame;
//    rect.origin.y += positionAdjustment;
//    [self.navigationItem.titleView setFrame:rect];
//    [self.pageControl setAlpha:percentage];
//}


@end
