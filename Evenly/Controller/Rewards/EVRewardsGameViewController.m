//
//  EVRewardsGameViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsGameViewController.h"
#import "EVHomeViewController.h"
#import "EVWebViewController.h"

#import "EVNavigationBarButton.h"
#import "EVSwitch.h"
#import "EVFacebookManager.h"

#import "EVRewardHeaderView.h"
#import "EVRewardCard.h"

#define NAVIGATION_BAR_OFFSET 44.0

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
    
    // TESTING ONLY
    self.reward = [[EVReward alloc] init];
    self.reward.selectedOptionIndex = NSNotFound;
    self.reward.options = @[ [NSDecimalNumber decimalNumberWithString:@"2.00"],
                             [NSDecimalNumber decimalNumberWithString:@"10.00"],
                             [NSDecimalNumber decimalNumberWithString:@"0.00"]];
    
    [self loadHeader];
    [self loadTopLabel];
    [self loadFooter];
    [self loadCards];
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

    int count;
    if (self.reward)
        count = MIN([self.reward.options count], [colors count]);
    else
        count = 3;
    
    CGFloat spacing = 20.0;
    
    CGFloat availableHeight = CGRectGetMinY(self.footerLabel.frame) - CGRectGetMaxY(self.topLabel.frame) - NAVIGATION_BAR_OFFSET;
    availableHeight -= count * spacing;
    CGFloat height = availableHeight / count;
    CGFloat width = MAX(190.0, height * 2.0);
    CGFloat xOrigin = (self.view.frame.size.width - width) / 2.0;
    
    for (int i = 0; i < count; i++) {
        EVRewardCard *card = [[EVRewardCard alloc] initWithFrame:CGRectMake(xOrigin,
                                                                            CGRectGetMaxY(self.topLabel.frame) + i*height + i*spacing,
                                                                            width,
                                                                            height)
                                                            text:EV_STRING_FROM_INT(i+1)
                                                           color:[colors objectAtIndex:i]];
        [card addTarget:self action:@selector(cardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:card];
        [cardsArray addObject:card];
    }
    self.cards = [NSArray arrayWithArray:cardsArray];    
}

- (void)loadFooter {
    self.footerLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 15)];
    self.footerLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.footerLabel.font = [EVFont bookFontOfSize:10];
    self.footerLabel.backgroundColor = [UIColor clearColor];
    self.footerLabel.textColor = [EVColor lightLabelColor];
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    self.footerLabel.linkAttributes = @{ NSForegroundColorAttributeName : [EVColor lightLabelColor],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    self.footerLabel.activeLinkAttributes = @{ NSForegroundColorAttributeName : [EVColor blueColor],
                                               NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    NSString *text = @"By playing, you agree to Evenly's terms of service";
    NSRange range = [text rangeOfString:@"terms of service"];
    [self.footerLabel setText:text];
    [self.footerLabel addLinkToURL:[EVUtilities tosURL] withRange:range];
    [self.footerLabel setDelegate:self];
    [self.view addSubview:self.footerLabel];
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
    if (self.reward.selectedOptionIndex == NSNotFound)
        [self didSelectOptionAtIndex:[self.cards indexOfObject:card]];
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
    EV_DISPATCH_AFTER(2.0, ^{
        [self updateInterface];
    });
    return;
    
    
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
    [self updateCards];
    
}

- (void)updateCards {
    EVRewardCard *card;
    NSDecimalNumber *amount;
    for (int i = 0; i < self.reward.options.count; i++) {
        card = [self.cards objectAtIndex:i];
        amount = [self.reward.options objectAtIndex:i];
        [card setAnimationEnabled:NO];
        [card setRewardAmount:amount animated:(i == self.reward.selectedOptionIndex)];
    }
}

- (void)changeNavButton {
    self.navigationItem.leftBarButtonItem = nil;
    [self.cancelButton removeFromSuperview];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    EVWebViewController *controller = [[EVWebViewController alloc] initWithURL:url];
    controller.title = [url isEqual:[EVUtilities tosURL]] ? @"Terms of Service" : @"Privacy Policy";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}


@end
