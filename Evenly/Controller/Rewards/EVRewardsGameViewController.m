//
//  EVRewardsGameViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsGameViewController.h"
#import "EVNavigationBarButton.h"

#import "EVRewardsHeaderView.h"
#import "EVRewardsSwitchView.h"
#import "EVRewardsSlider.h"
#import "EVRewardsFooterView.h"

@interface EVRewardsGameViewController ()

@property (nonatomic, strong) EVReward *reward;

@property (nonatomic, strong) EVRewardsHeaderView *headerView;
@property (nonatomic, strong) UIView *stripe;
@property (nonatomic, strong) EVRewardsSwitchView *switchView;
@property (nonatomic, strong) NSArray *sliders;
@property (nonatomic, strong) EVRewardsFooterView *footerView;

- (void)loadHeaderView;
- (void)loadSwitchView;
- (void)loadSliders;
- (void)loadFooterView;

@end

@implementation EVRewardsGameViewController

- (id)initWithReward:(EVReward *)reward {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.reward = reward;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Evenly Rewards";
        self.cancelButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.hidesBackButton = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadHeaderView];
    [self loadSwitchView];
    [self loadSliders];
    [self loadFooterView];
}

- (void)loadHeaderView {
    self.headerView = [[EVRewardsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 96)];
    [self.view addSubview:self.headerView];
}

- (void)loadSwitchView {
    self.stripe = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.view.frame.size.width, 1)];
    self.stripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self.view addSubview:self.stripe];
    
    self.switchView = [[EVRewardsSwitchView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.stripe.frame), self.view.frame.size.width, 60)];
    [self.switchView.shareSwitch addTarget:self action:@selector(shareSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.switchView];
    
    self.reward.willShare = self.switchView.shareSwitch.isOn;
}

- (void)loadSliders {
    CGFloat height = 72;
    
    NSArray *colors = @[ [EVColor blueColor], [EVColor lightColor], [EVColor lightGreenColor] ];
    NSArray *words = @[ @"Blue", @"Gray", @"Green" ];
    
    NSMutableArray *slidersArray = [NSMutableArray array];
    for (int i = 0; i < 3 /* [self.reward.options count] */; i++) {
        EVRewardsSlider *slider = [[EVRewardsSlider alloc] initWithFrame:CGRectMake(0,
                                                                                    CGRectGetMaxY(self.switchView.frame) + i*height,
                                                                                    self.view.frame.size.width,
                                                                                    height)];
        [slider setForegroundColor:[colors objectAtIndex:i]];
        [slider.label setText:[words objectAtIndex:i]];
        [self.view addSubview:slider];
        [slidersArray addObject:slider];
    }
    self.sliders = [NSArray arrayWithArray:slidersArray];
}

- (void)loadFooterView {
    self.footerView = [[EVRewardsFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([[self.sliders lastObject] frame]), self.view.frame.size.width,  self.view.frame.size.height - CGRectGetMaxY([[self.sliders lastObject] frame]))];
    self.footerView.backgroundColor = [UIColor whiteColor];
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.footerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSTimeInterval interval = 0.1;
    int i = 0;
    for (EVRewardsSlider *slider in self.sliders) {
        EV_DISPATCH_AFTER(interval * (i++ *2), ^{
            EV_PERFORM_ON_MAIN_QUEUE(^{
                [slider makeAnAppearanceWithDuration:EV_DEFAULT_ANIMATION_DURATION completion:^{
                }];
            });
        });
    }

    
    EV_DISPATCH_AFTER(interval * (++i * 2), ^{
        EV_PERFORM_ON_MAIN_QUEUE(^{
            [self.sliders makeObjectsPerformSelector:@selector(pulse)];
        });
    });
}

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)shareSwitchChanged:(EVSwitch *)sender {
    self.reward.willShare = self.switchView.shareSwitch.isOn;
}

@end
