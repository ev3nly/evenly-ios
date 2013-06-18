//
//  EVRequestViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController_NEW.h"
#import "EVNavigationBarButton.h"
#import "EVPageControl.h"
#import "EVPrivacySelectorView.h"
#import "EVBackButton.h"

#define TITLE_PAGE_CONTROL_Y_OFFSET 5.0

@interface EVRequestViewController_NEW ()

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVBackButton *backButton;
@property (nonatomic, strong) EVNavigationBarButton *nextButton;
@property (nonatomic, strong) EVNavigationBarButton *requestButton;
@property (nonatomic, strong) EVPageControl *pageControl;
@property (nonatomic, strong) EVPrivacySelectorView *privacySelector;

- (void)loadCancelButton;
- (void)loadBackButton;
- (void)loadNextButton;
- (void)loadRequestButton;
- (void)loadPageControl;
- (void)loadPrivacySelector;
- (void)loadContentViews;

@end

@implementation EVRequestViewController_NEW

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Request";
        self.phase = EVRequestPhaseWho;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCancelButton];
    [self loadBackButton];
    [self loadNextButton];
    [self loadRequestButton];
    [self loadPageControl];
//    [self loadPrivacySelector];
    [self loadContentViews];
}

- (void)loadCancelButton {
    self.cancelButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
}

- (void)loadBackButton {
    self.backButton = [EVBackButton button];
    [self.backButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadNextButton {
    self.nextButton = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [self.nextButton addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
}

- (void)loadRequestButton {
    self.requestButton = [[EVNavigationBarButton alloc] initWithTitle:@"Request"];
    [self.requestButton addTarget:self action:@selector(requestButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadPageControl {
    self.pageControl = [[EVPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl sizeToFit];
    [self.pageControl setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width / 2.0,
                                            self.titleLabel.frame.size.height + 5.0)];
    [self.navigationController.navigationBar addSubview:self.pageControl];
    CGFloat positionAdjustment = -TITLE_PAGE_CONTROL_Y_OFFSET;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:positionAdjustment
                                                                  forBarMetrics:UIBarMetricsDefault];
    CGRect rect = self.titleLabel.frame;
    rect.origin.y += positionAdjustment;
    [self.navigationItem.titleView setFrame:rect];
}

- (void)loadPrivacySelector {
    _privacySelector = [[EVPrivacySelectorView alloc] initWithFrame:[self privacySelectorFrame]];
    [self.view addSubview:_privacySelector];
}

- (CGRect)privacySelectorFrame {
    float yOrigin = self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - [EVPrivacySelectorView lineHeight] - self.navigationController.navigationBar.bounds.size.height;
    return CGRectMake(0,
                      yOrigin,
                      self.view.bounds.size.width,
                      [EVPrivacySelectorView lineHeight] * [EVPrivacySelectorView numberOfLines]);
}

- (void)loadContentViews {
    self.initialView = [[EVRequestInitialView alloc] initWithFrame:[self contentViewFrame]];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleAmountView = [[EVRequestSingleAmountView alloc] initWithFrame:[self contentViewFrame]];
    self.singleAmountView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.detailsView = [[EVRequestDetailsView alloc] initWithFrame:[self contentViewFrame]];
    self.detailsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (CGRect)contentViewFrame {
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT);
}

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)backButtonPress:(id)sender {
    [self popViewAnimated:YES];
    self.phase--;
    [self setUpNavBar];
}

- (void)nextButtonPress:(id)sender {
    if (self.phase == EVRequestPhaseWho)
    {
        [self.singleAmountView.titleLabel setText:@"Zach Abrams owes me"];
        [self pushView:self.singleAmountView animated:YES];
        self.phase = EVRequestPhaseHowMuch;
    }
    else if (self.phase == EVRequestPhaseHowMuch)
    {
        NSString *title = [NSString stringWithFormat:@"Zach Abrams owes me %@ for", self.singleAmountView.amountField.text];
        [self.detailsView.titleLabel setText:title];
        [self pushView:self.detailsView animated:YES];
        self.phase = EVRequestPhaseWhatFor;
    }
    [self setUpNavBar];
}

- (void)setUpNavBar {
    UIView *leftView, *rightView;
    leftView = self.backButton;
    rightView = self.nextButton;
    if (self.phase == EVRequestPhaseWho)
    {
        leftView = self.cancelButton;
    }
    else if (self.phase == EVRequestPhaseWhatFor)
    {
        rightView = self.requestButton;
    }
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftView] animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightView] animated:YES];
    [self.pageControl setCurrentPage:self.phase];
}

@end
