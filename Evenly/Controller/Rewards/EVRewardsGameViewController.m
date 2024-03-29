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
#import "EVRewardBalanceView.h"
#import "EVRewardCard.h"
#import "EVRewardsExhaustedView.h"

#define NAVIGATION_BAR_OFFSET 44.0

#define HEADER_HEIGHT 50.0
#define TOP_LABEL_HEIGHT 45.0

#define CARD_SPACING 20.0
#define MAX_CARD_WIDTH 190.0

#define DEFAULT_NUMBER_OF_REWARD_OPTIONS 3

#define VERTICAL_CARD_SPACING 20

@interface EVRewardsGameViewController ()

@property (nonatomic, strong) EVReward *reward;

@property (nonatomic, strong) UIView *headerContainer;
@property (nonatomic, strong) EVRewardHeaderView *headerView;
@property (nonatomic, strong) EVSwitch *shareSwitch;

@property (nonatomic, strong) EVRewardBalanceView *balanceView;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *curiousLabel;

@property (nonatomic, strong) TTTAttributedLabel *footerLabel;

@property (nonatomic, strong) NSArray *cards;

@property (nonatomic, strong) EVRewardsExhaustedView *rewardsExhaustedView;

- (void)loadHeader;
- (void)loadBalanceView;
- (void)loadTopLabels;
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
        self.cancelButton = [self defaultCancelButton];
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
    [self loadBalanceView];
    [self loadTopLabels];
    [self loadFooter];
    [self loadCards];
    
    if (self.reward == [EVReward rewardsExhaustedSentinel])
    {
        [self loadRewardsExhaustedView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.rewardsExhaustedView && ![self hasDealtCards])
    {
        EV_DISPATCH_AFTER(0.1, ^{
            [self dealCards];
        });
    }
}

#pragma mark - View Loading

- (void)loadHeader {
    self.headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [self totalBarHeight], self.view.frame.size.width, HEADER_HEIGHT)];
    [self.view addSubview:self.headerContainer];
    
    self.headerView = [[EVRewardHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)];
    
    self.shareSwitch = [[EVSwitch alloc] init];
    [self.shareSwitch addTarget:self action:@selector(shareSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.headerView setShareSwitch:self.shareSwitch];
    [self.shareSwitch setOn:[[EVCIA me] rewardSharingSetting]];
    [self.headerContainer addSubview:self.headerView];
}

- (void)loadBalanceView {
    self.balanceView = [[EVRewardBalanceView alloc] initWithFrame:[self balanceViewFrame]];
}

- (void)loadTopLabels {
    self.topLabel = [[UILabel alloc] initWithFrame:[self topLabelFrame]];
    self.topLabel.contentMode = UIViewContentModeCenter;
    self.topLabel.font = [EVFont bookFontOfSize:15];
    self.topLabel.textColor = [EVColor mediumLabelColor];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.text = @"Flip to select your reward. Choose wisely!";
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.topLabel];
    
    self.curiousLabel = [[UILabel alloc] initWithFrame:[self topLabelOffScreenLeftFrame]];
    self.curiousLabel.contentMode = UIViewContentModeCenter;
    self.curiousLabel.font = [EVFont bookFontOfSize:15];
    self.curiousLabel.textColor = [EVColor mediumLabelColor];
    self.curiousLabel.backgroundColor = [UIColor clearColor];
    self.curiousLabel.text = @"Curious? Flip to reveal the other rewards.";
    self.curiousLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)loadCards {
    NSMutableArray *cardsArray = [NSMutableArray array];
    
    for (int i = 0; i < [self numberOfRewardOptions]; i++) {
        EVRewardCard *card = [[EVRewardCard alloc] initWithFrame:CGRectMake(0, 0, [self cardSize].width, [self cardSize].height)
                                                            text:EV_STRING_FROM_INT(i+1)
                                                           color:[[self cardColors] objectAtIndex:i]];
        [card addTarget:self action:@selector(cardTapped:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)loadRewardsExhaustedView {
    self.rewardsExhaustedView = [[EVRewardsExhaustedView alloc] initWithFrame:self.view.bounds];
    self.rewardsExhaustedView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self.view addSubview:self.rewardsExhaustedView];
}

#pragma mark - Button Actions

- (void)doneButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [EVCIA reloadMe];
}

- (void)cardTapped:(EVRewardCard *)card {
    DLog(@"Card tapped");
    if (self.reward.selectedOptionIndex == NSNotFound)
        [self didSelectOptionAtIndex:[self.cards indexOfObject:card]];
}

- (void)shareSwitchChanged:(EVSwitch *)sender {
    self.reward.willShare = self.shareSwitch.isOn;
    [[EVCIA me] setRewardSharingSetting:self.shareSwitch.isOn];
    if ([sender isOn]) {
        [self acquirePublishPermissionsWithCompletion:NULL];
    }
}

- (void)didSelectOptionAtIndex:(NSInteger)index {
    self.reward.selectedOptionIndex = index;
    [self flipBalanceView];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.cancelButton.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         self.navigationItem.leftBarButtonItem = nil;
                         [self.cancelButton removeFromSuperview];
                     }];
    for (EVRewardCard *card in self.cards) {
        [card setUserInteractionEnabled:NO];
    }

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
        action[@"fb:explicitly_shared"] = @"true";
        [FBRequestConnection startForPostWithGraphPath:@"me/evenlyapp:win"
                                           graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                               DLog(@"Result: %@", result);
                                               DLog(@"Error? %@", error);
                                           }];
    };
}

- (void)share {
    [self acquirePublishPermissionsWithCompletion:[self shareBlock]];
}

- (void)acquirePublishPermissionsWithCompletion:(void (^)(void))completion {
    [EVFacebookManager requestPublishPermissionsWithCompletion:^{
        if (completion)
            completion();
    }];
}

#pragma mark - UI Updates

- (void)updateInterface {
    [self updateCards];
    [self changeNavButton];
}

- (void)updateCards {
    EVRewardCard *card;
    NSDecimalNumber *amount;
    for (int i = 0; i < self.reward.options.count; i++) {
        card = [self.cards objectAtIndex:i];
        [card setUserInteractionEnabled:YES];
        [card setAnimationEnabled:NO];

        amount = [self.reward.options objectAtIndex:i];
        BOOL animated = (i == self.reward.selectedOptionIndex);
        void (^completion)(void) = NULL;
        if (animated)
            completion = ^{
                EV_DISPATCH_AFTER(1.0, ^{
                    if (![[self.reward selectedAmount] isEqual:[NSDecimalNumber zero]])
                        [self animateAmountLabel];
                    else {
                        [self switchTopLabel];
                    }
                });
            };
        [card setRewardAmount:amount
                     animated:animated
                   completion:completion];
    }
}

- (void)changeNavButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];
    self.doneButton.alpha = 0.0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.doneButton.alpha = 1.0;
                     } completion:^(BOOL finished) {

                     }];
}

#pragma mark - Animations

- (void)dealCards {
    NSTimeInterval spacing = 0.18;
    NSTimeInterval duration = EV_DEFAULT_ANIMATION_DURATION;
    int i = 0;
    for (EVRewardCard *card in self.cards) {
        [card setSize:[self cardSize]];
        [card setCenter:[self cardOffscreenCenter]];
        [card setTransform:CGAffineTransformMakeRotation(M_PI / 2.0)];
        [self.view addSubview:card];
        EV_DISPATCH_AFTER(i*spacing, ^{
            [UIView animateWithDuration:duration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGRect frame = [self cardFrameForIndex:i];
                                 CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
                                 [card setCenter:center];
                                 [card setTransform:CGAffineTransformIdentity];
                             } completion:NULL];
        });
        i++;
    }
}

- (void)flipBalanceView {
    self.balanceView.frame = CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT);
    [UIView transitionFromView:self.headerView
                        toView:self.balanceView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:^(BOOL finished) {

                    }];
}

- (void)animateAmountLabel {
    if (self.reward.selectedOptionIndex == NSNotFound)
        return;
    
    EVRewardCard *card = [self.cards objectAtIndex:self.reward.selectedOptionIndex];
    
    UILabel *faceLabel = card.face.amountLabel;
    UILabel *newLabel = [faceLabel roughCopy];
    newLabel.textColor = [EVColor mediumLabelColor];
    
    CGPoint faceLabelCenter = [self.view convertPoint:faceLabel.center fromView:card.face];
    CGSize textSize = [faceLabel.text _safeSizeWithAttributes:@{NSFontAttributeName: faceLabel.font}];
    [newLabel setSize:textSize];
    newLabel.center = faceLabelCenter;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.view addSubview:newLabel];
                         CGRect destinationRect = [self.view convertRect:self.balanceView.balanceLabel.frame fromView:self.balanceView];
                         destinationRect.origin.x = CGRectGetMaxX(destinationRect) - newLabel.frame.size.width;
                         destinationRect.size.width = newLabel.frame.size.width;
                         [newLabel setFrame:destinationRect];
                     }
                     completion:^(BOOL finished) {
                         [newLabel removeFromSuperview];
                         [self updateBalance];
                         EV_DISPATCH_AFTER(0.8, ^{
                             [self switchTopLabel];
                         });
                     }];
}

- (void)updateBalance {
    NSDecimalNumber *myBalance = [[EVCIA me] balance];
    NSDecimalNumber *rewardAmount = self.reward.selectedAmount;

    // JH: Per Crashlytics #114, we're seeing some weird NSDecimalNumberOverflowExceptions being raised
    // in this method when the addition takes place.  I have no idea why, considering we're never even coming
    // close to overflowing NSDecimalNumber.  In any case, my solution is to catch the exception and,
    // instead of doing the addition locally, just reload Me to update the balance.
    @try {
        NSDecimalNumber *newBalance = [myBalance decimalNumberByAdding:rewardAmount];
        [self.balanceView.balanceLabel setText:[EVStringUtility amountStringForAmount:newBalance]];
        [[[EVCIA sharedInstance] me] setBalance:newBalance];
    }
    @catch (NSException *exception) {
        [EVCIA reloadMe];
    }
}

- (void)switchTopLabel {
    self.curiousLabel.frame = [self topLabelOffScreenLeftFrame];
    [self.view addSubview:self.curiousLabel];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.curiousLabel.frame = [self topLabelFrame];
                         self.topLabel.frame = [self topLabelOffScreenRightFrame];
                     } completion:^(BOOL finished) {
                         [self.topLabel removeFromSuperview];
                         EV_DISPATCH_AFTER(EV_DEFAULT_ANIMATION_DURATION, ^{
                             [self pulseUnselectedCards];
                         });
                     }];
}

- (void)pulseUnselectedCards {
    EVRewardCard *card;
    for (int i = 0; i < self.reward.options.count; i++) {
        card = [self.cards objectAtIndex:i];
        if (i != self.reward.selectedOptionIndex)
            [card pulse];
    }
}

#pragma mark - Animation Helpers

- (CGSize)cardSize {
    int count = [self numberOfRewardOptions];
    CGFloat availableHeight = CGRectGetMinY(self.footerLabel.frame) - CGRectGetMaxY(self.topLabel.frame);
    availableHeight -= count * CARD_SPACING;
    CGFloat height = availableHeight / count;
    CGFloat width = MIN(MAX_CARD_WIDTH, height * 2.0);
    return CGSizeMake((int)width, (int)height);
}

- (CGPoint)cardOffscreenCenter {
    CGSize size = [self cardSize];
    CGFloat xOrigin = -size.width;
    CGFloat yOrigin = (self.view.frame.size.height - size.height) / 2.0;
    return CGPointMake(xOrigin + size.width / 2.0, yOrigin + size.height / 2.0);
}

- (CGRect)cardFrameForIndex:(NSInteger)i {
    CGFloat spacing = VERTICAL_CARD_SPACING;
    CGSize size = [self cardSize];
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat xOrigin = (self.view.frame.size.width - width) / 2.0;
    CGRect frame = CGRectMake(xOrigin,
                              CGRectGetMaxY(self.topLabel.frame) + i*height + i*spacing,
                              width,
                              height);
    return frame;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    EVWebViewController *controller = [[EVWebViewController alloc] initWithURL:url];
    controller.title = [url isEqual:[EVUtilities tosURL]] ? @"Terms of Service" : @"Privacy Policy";
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Utility

- (int)numberOfRewardOptions {
    int count;
    if (self.reward)
        count = MIN([self.reward.options count], [[self cardColors] count]);
    else
        count = DEFAULT_NUMBER_OF_REWARD_OPTIONS;
    return count;
}

- (NSArray *)cardColors {
    return @[ [EVColor blueColor], [EVColor lightGreenColor], [EVColor darkColor], [EVColor lightRedColor] ];
}

- (BOOL)hasDealtCards {
    EVRewardCard *card = [self.cards firstObject];
    if (card.superview)
        return YES;
    return NO;
}
#pragma mark - Frames

- (CGRect)topLabelOffScreenLeftFrame {
    return CGRectMake(-self.view.frame.size.width,
                      CGRectGetMaxY(self.headerContainer.frame),
                      self.view.frame.size.width,
                      TOP_LABEL_HEIGHT);
}

- (CGRect)topLabelFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.headerContainer.frame),
                      self.view.frame.size.width,
                      TOP_LABEL_HEIGHT);
}

- (CGRect)topLabelOffScreenRightFrame {
    return CGRectMake(self.view.frame.size.width,
                      CGRectGetMaxY(self.headerContainer.frame),
                      self.view.frame.size.width,
                      TOP_LABEL_HEIGHT);
}

- (CGRect)balanceViewFrame {
    return CGRectMake(0,
                      -HEADER_HEIGHT,
                      self.view.frame.size.width,
                      HEADER_HEIGHT);
}

@end
