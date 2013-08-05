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
#import "EVRewardsAfterView.h"

#import "EVHomeViewController.h"
#import "EVFacebookManager.h"

#define AFTER_VIEW_X_ORIGIN 95
#define AFTER_VIEW_Y_ORIGIN 0
#define AFTER_VIEW_WIDTH 225
#define AFTER_VIEW_HEIGHT 96

@interface EVRewardsGameViewController ()

@property (nonatomic, strong) EVReward *reward;

@property (nonatomic, strong) EVRewardsHeaderView *headerView;
@property (nonatomic, strong) UIView *stripe;
@property (nonatomic, strong) EVRewardsSwitchView *switchView;
@property (nonatomic, strong) NSArray *sliders;
@property (nonatomic, strong) EVRewardsFooterView *footerView;
@property (nonatomic, strong) EVRewardsAfterView *afterView;

@property (nonatomic, strong) EVRewardsSlider *chosenSlider;

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
        
        self.doneButton = [[EVNavigationBarButton alloc] initWithTitle:@"Done"];
        [self.doneButton addTarget:self action:@selector(doneButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.swipeGestureRecognizer.enabled = NO; // Disable back swiping.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.hidesBackButton = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.exclusiveTouch = YES;
    [self loadHeaderView];
    [self loadSwitchView];
    [self loadSliders];
    [self loadFooterView];
}

- (void)loadHeaderView {
    self.headerView = [[EVRewardsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 96)];
    [self.view addSubview:self.headerView];
    
    self.afterView = [[EVRewardsAfterView alloc] initWithFrame:[self afterViewFrame]];
}

- (CGRect)afterViewFrame {
    return CGRectMake(AFTER_VIEW_X_ORIGIN,
                      AFTER_VIEW_Y_ORIGIN,
                      AFTER_VIEW_WIDTH,
                      AFTER_VIEW_HEIGHT);
}

- (void)loadSwitchView {
    self.stripe = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.view.frame.size.width, 1)];
    self.stripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self.view addSubview:self.stripe];
    
    self.switchView = [[EVRewardsSwitchView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.stripe.frame), self.view.frame.size.width, 60)];
    [self.switchView.shareSwitch setOn:[EVFacebookManager hasPublishPermissions]];
    [self.switchView.shareSwitch addTarget:self action:@selector(shareSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.switchView];
    
    self.reward.willShare = self.switchView.shareSwitch.isOn;
}

- (void)loadSliders {
    CGFloat height = 72;
    
    NSArray *words = @[ @"Blue", @"Gray", @"Green" ];
    
    NSMutableArray *slidersArray = [NSMutableArray array];
    for (int i = 0; i < 3 /* [self.reward.options count] */; i++) {
        EVRewardsSlider *slider = [[EVRewardsSlider alloc] initWithFrame:CGRectMake(0,
                                                                                    CGRectGetMaxY(self.switchView.frame) + i*height,
                                                                                    self.view.frame.size.width,
                                                                                    height)
                                   sliderColor:(EVRewardsSliderColor)i];
        [slider.label setText:[words objectAtIndex:i]];
        [slider addTarget:self action:@selector(optionSelected:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:slider];
        [slidersArray addObject:slider];
        slider.hidden = YES;
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
        slider.hidden = NO;
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

- (void)doneButtonPress:(id)sender {
    if ([self.reward.selectedAmount isEqual:[NSDecimalNumber zero]]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardRedeemedNotification
                                                            object:self
                                                          userInfo:@{ @"reward" : self.reward,
                                                                       @"label" : self.chosenSlider.backgroundView.rewardCard.label }];
    }
}

- (void)shareSwitchChanged:(EVSwitch *)sender {
    self.reward.willShare = self.switchView.shareSwitch.isOn;
    if ([sender isOn]) {
        [EVFacebookManager openSessionWithCompletion:^{
            [EVFacebookManager requestPublishPermissionsWithCompletion:^{
                DLog(@"Received publish permissions");
            }];
        }];
    }
}

- (void)optionSelected:(EVRewardsSlider *)slider {
    if (self.reward.selectedOptionIndex != NSNotFound) {
        return;
    }
    
    self.chosenSlider = slider;
    
    for (EVRewardsSlider *slider in self.sliders) {
        slider.enabled = NO;
    }
    
    int index = [self.sliders indexOfObject:slider];
    self.reward.selectedOptionIndex = index;
    self.reward.willShare = self.switchView.shareSwitch.isOn;
    [self.reward redeemWithSuccess:^(EVReward *reward) {
        self.reward = reward;
        [self updateInterface];
        if (self.switchView.shareSwitch.on && ![self.reward.selectedAmount isEqual:[NSDecimalNumber zero]]) {
            [self share];
        }
    } failure:^(NSError *error) {
        DLog(@"Rewarding failed");
    }];
}

- (void (^)(void))shareBlock {
    return ^{
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        NSString *amountWithoutDollarSign = [[EVStringUtility amountStringForAmount:self.reward.selectedAmount] stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        action[@"reward"] = [NSString stringWithFormat:@"https://paywithivy.com/facebook/reward?amount=%@", amountWithoutDollarSign];
        [FBRequestConnection startForPostWithGraphPath:@"me/evenlyapp:win"
                                           graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                               DLog(@"Result: %@", result);
                                               DLog(@"Error? %@", error);
//                                               if (result && [result valueForKey:@"id"]) {
//                                                   [self.reward setFacebookStoryID:[result valueForKey:@"id"]];
//                                                   [self.reward updateWithSuccess:^{
//                                                       DLog(@"Updated reward with FB story id");
//                                                   } failure:^(NSError *error) {
//                                                       DLog(@"Failed to update: %@", error);
//                                                   }];
//                                               }
                                           }];
    };
}

- (void)share {
    if (![EVFacebookManager isConnected]) {
        [EVFacebookManager openSessionWithCompletion:^{
            [EVFacebookManager requestPublishPermissionsWithCompletion:[self shareBlock]];
        }];
    } else if (![EVFacebookManager hasPublishPermissions]) {
        [EVFacebookManager requestPublishPermissionsWithCompletion:[self shareBlock]];
    } else {
        [self shareBlock]();
    }
}

#pragma mark - Managing Sliders

- (void)updateInterface {
    [self updateSliders];
    NSString *topPhrase, *bottomPhrase = nil;
    if (![self.reward.selectedAmount isEqual:[NSDecimalNumber zero]]) {
        topPhrase = [NSString stringWithFormat:@"Nice! You've earned %@!", [EVStringUtility amountStringForAmount:self.reward.selectedAmount]];
    } else {
        topPhrase = @"Better luck next time!";
    }
    bottomPhrase = @"Curious?  Swipe to reveal the other rewards.";
    self.afterView.headerLabel.text = topPhrase;
    self.afterView.otherOptionsLabel.text = bottomPhrase;
    
    [self.view addSubview:self.afterView];
    [self changeNavButton];
}

- (void)updateSliders {
    EVRewardsSlider *slider;
    NSDecimalNumber *amount;
    for (int i = 0; i < self.reward.options.count; i++) {
        slider = [self.sliders objectAtIndex:i];
        amount = [self.reward.options objectAtIndex:i];
        [slider.backgroundView stopAnimating];
        slider.animationEnabled = NO;
        slider.enabled = YES;
        [slider setRewardAmount:amount animated:(i == self.reward.selectedOptionIndex)];
    }
}

- (void)changeNavButton {
    self.navigationItem.leftBarButtonItem = nil;
    [self.cancelButton removeFromSuperview];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];
}

@end
