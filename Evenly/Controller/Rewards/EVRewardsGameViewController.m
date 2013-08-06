//
//  EVRewardsGameViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsGameViewController.h"
#import "EVNavigationBarButton.h"
#import "EVSwitch.h"
#import "EVHomeViewController.h"
#import "EVFacebookManager.h"

#import "EVRewardHeaderView.h"
#import "EVRewardCard.h"
#import "TTTAttributedLabel.h"

#define HEADER_HEIGHT 50.0
#define TOP_LABEL_HEIGHT 45.0

#define AFTER_VIEW_X_ORIGIN 95
#define AFTER_VIEW_Y_ORIGIN 0
#define AFTER_VIEW_WIDTH 225
#define AFTER_VIEW_HEIGHT 96

@interface EVRewardsGameViewController ()

@property (nonatomic, strong) EVReward *reward;

@property (nonatomic, strong) EVRewardHeaderView *headerView;
@property (nonatomic, strong) EVSwitch *shareSwitch;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) TTTAttributedLabel *footerLabel;

@property (nonatomic, strong) NSArray *cards;

- (void)loadHeader;
- (void)loadTopLabel;
- (void)loadCards;
- (void)loadFooter;

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
    
    [self loadHeader];
    [self loadTopLabel];
    [self loadCards];
    [self loadFooter];
}

- (void)loadHeader {
    self.headerView = [[EVRewardHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)];
    
    self.shareSwitch = [[EVSwitch alloc] init];
    [self.shareSwitch addTarget:self action:@selector(shareSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.headerView setShareSwitch:self.shareSwitch];
    [self.view addSubview:self.headerView];
}

- (void)loadTopLabel {
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetMaxY(self.headerView.frame),
                                                              self.view.frame.size.width,
                                                              TOP_LABEL_HEIGHT)];
    self.topLabel.contentMode = UIViewContentModeCenter;
    self.topLabel.font = [EVFont bookFontOfSize:15];
    self.topLabel.textColor = [EVColor mediumLabelColor];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.text = @"Flip to select your reward. Choose wisely!";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.topLabel];
}

- (void)loadCards {
    NSArray *colors = @[ [EVColor blueColor], [EVColor lightGreenColor], [EVColor darkColor], [EVColor lightRedColor] ];
    NSMutableArray *cardsArray = [NSMutableArray array];
    CGFloat height = 80.0;
    CGFloat spacing = 20.0;
    CGFloat xOrigin = 65.0;
    CGFloat width = 190.0;
    
    for (int i = 0; i < 3 /* MIN([self.reward.options count], [colors count]) */; i++) {
        EVRewardCard *card = [[EVRewardCard alloc] initWithFrame:CGRectMake(xOrigin,
                                                                            CGRectGetMaxY(self.topLabel.frame) + i*height + i*spacing,
                                                                            width,
                                                                            height)
                                                            text:EV_STRING_FROM_INT(i+1)
                                                           color:[colors objectAtIndex:i]];
        [card addTarget:self action:@selector(cardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:card];
    }
    self.cards = [NSArray arrayWithArray:cardsArray];    
}

- (void)loadFooter {
    self.footerLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 15, self.view.frame.size.width, 15)];
    self.footerLabel.font = [EVFont defaultFontOfSize:10];
    self.footerLabel.backgroundColor = [UIColor clearColor];
    self.footerLabel.textColor = [EVColor lightLabelColor];
    NSString *text = @"By playing, you agree to Evenly's terms of service";
    NSRange range = [text rangeOfString:@"terms of service"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
                                                          userInfo:@{ @"reward" : self.reward }];
    }
}

- (void)cardTapped:(EVRewardCard *)card {
    DLog(@"Card tapped");
}

- (void)shareSwitchChanged:(EVSwitch *)sender {
    self.reward.willShare = self.shareSwitch.isOn;
    if ([sender isOn]) {
        [EVFacebookManager openSessionWithCompletion:^{
            [EVFacebookManager requestPublishPermissionsWithCompletion:^{
                DLog(@"Received publish permissions");
            }];
        }];
    }
}

- (void)didSelectOptionAtIndex:(NSInteger)index {
    self.reward.selectedOptionIndex = index;
    self.reward.willShare = self.shareSwitch.isOn;
    [self.reward redeemWithSuccess:^(EVReward *reward) {
        self.reward = reward;
        [self updateInterface];
        if (self.shareSwitch.on && ![self.reward.selectedAmount isEqual:[NSDecimalNumber zero]]) {
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

- (void)updateInterface {
    
}

- (void)changeNavButton {
    self.navigationItem.leftBarButtonItem = nil;
    [self.cancelButton removeFromSuperview];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];
}

@end
