//
//  EVTippingViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTippingViewController.h"
#import "EVChooseTipView.h"
#import "EVExchangeWhatForView.h"
#import "EVNavigationBarButton.h"
#import "EVBackButton.h"
#import "EVValidator.h"
#import "EVTip.h"
#import "EVSharingSelectorView.h"
#import <QuartzCore/QuartzCore.h>

@interface EVTippingViewController ()

@end

@implementation EVTippingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Tipping";
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.chooseTipView.layer.animationKeys)
        self.chooseTipView.frame = self.view.bounds;
}
#pragma mark - View Loading

- (NSArray *)fakeTips {
    NSMutableArray *tips = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        EVTip *tip = [EVTip new];
        tip.image = [UIImage imageNamed:@"Bearhug"];
        tip.title = @"Bearhug";
        tip.amount = [NSDecimalNumber decimalNumberWithString:@"0.05"];
        [tips addObject:tip];
    }
    return [NSArray arrayWithArray:tips];
}

- (void)loadContentViews {
    self.initialView = [[EVPaymentWhoView alloc] initWithFrame:[self.view bounds]];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.chooseTipView = [[EVChooseTipView alloc] initWithFrame:self.view.bounds];;
    self.chooseTipView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.chooseTipView.tips = [self fakeTips];
    
    self.whatForView = [[EVExchangeWhatForView alloc] initWithFrame:[self.view bounds]];
    self.whatForView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self.whatForView addSubview:self.privacySelector];
    
    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (void)loadPrivacySelector {
    self.privacySelector = [[EVSharingSelectorView alloc] initWithFrame:[self privacySelectorFrame]];
}

- (void)setUpReactions {
    [super setUpReactions];
    
    [RACAble(self.chooseTipView.selectedTip) subscribeNext:^(EVTip *tip) {
        if (tip)
            [self advancePhase];
    }];
}

#pragma mark - Basic Interface

- (void)sendExchangeToServer {
//    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
//    
//    self.payment.memo = self.whatForView.descriptionField.text;
//    [self setVisibilityForExchange:self.payment];
//    
//    [self.payment saveWithSuccess:^{
//        
//        // Don't allow the balance to fall below 0.  If a payment amount is > available balance, it gets
//        // paid via credit card, leaving the balance unaffected.
//        NSDecimalNumber *newBalance = [[[EVCIA me] balance] decimalNumberBySubtracting:self.payment.amount];
//        if ([newBalance compare:[NSDecimalNumber zero]] != NSOrderedAscending) {
//            [[EVCIA me] setBalance:newBalance];
//        }
//        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
//        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
//        
//        EVStory *story = [EVStory storyFromCompletedExchange:self.payment];
//        story.publishedAt = [NSDate date];
//        [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification object:nil userInfo:@{ @"story" : story }];
//        
//        void (^completion)(void) = NULL;
//        
//        if (self.payment.reward)
//        {
//            EVRewardsGameViewController *rewardsViewController = [[EVRewardsGameViewController alloc] initWithReward:self.payment.reward];
//            [self unloadPageControlAnimated:YES];
//            completion = ^{
//                [self.navigationController pushViewController:rewardsViewController animated:YES];
//            };
//        } else {
//            completion = ^(void) {
//                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            };
//        }
//        [EVStatusBarManager sharedManager].duringSuccess = completion;
//        
//    } failure:^(NSError *error) {
//        DLog(@"failed to create %@", NSStringFromClass([self.payment class]));
//        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
//        [[self rightButtonForPhase:self.phase] setEnabled:YES];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]];
//    }];
}

- (void)advanceToHowMuch {
    self.tip = [EVTip new];
    EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
    self.tip.to = recipient;
    [self pushView:self.chooseTipView animated:YES];
}

- (void)advanceToWhatFor {
    EVTip *selectedTip = self.chooseTipView.selectedTip;
    self.tip.image = selectedTip.image;
    self.tip.title = selectedTip.title;
    self.tip.amount = selectedTip.amount;
    EVExchangeWhatForHeader *header = [EVExchangeWhatForHeader tipHeaderForPerson:self.tip.to];
    self.whatForView.whatForHeader = header;
    self.whatForView.tip = self.tip;
    [self pushView:self.whatForView animated:YES];
}
#pragma mark - Validation

- (BOOL)shouldAdvanceToWhatFor {
    return (self.chooseTipView.selectedTip != nil);
}

- (BOOL)shouldPerformAction {
    return NO;
}

#pragma mark - Utility

- (NSString *)actionButtonText {
    return @"Tip";
}

- (CGRect)privacySelectorFrame {    
    float yOrigin = self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - [EVSharingSelectorView lineHeight];
    return CGRectMake(0,
                      yOrigin,
                      self.view.bounds.size.width,
                      [EVSharingSelectorView lineHeight] * [EVSharingSelectorView numberOfLines]);
}

@end
