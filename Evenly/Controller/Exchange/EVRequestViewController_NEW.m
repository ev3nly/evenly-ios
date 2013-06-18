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

#define TITLE_PAGE_CONTROL_Y_OFFSET 5.0

@interface EVRequestViewController_NEW ()

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVNavigationBarButton *nextButton;
@property (nonatomic, strong) EVPageControl *pageControl;


- (void)loadNextButton;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCancelButton];
    [self loadNextButton];
    [self loadPageControl];
}

- (void)loadCancelButton {
    self.cancelButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
}

- (void)loadNextButton {
    self.nextButton = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [self.nextButton addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
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

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)nextButtonPress:(id)sender {
    
}

@end
