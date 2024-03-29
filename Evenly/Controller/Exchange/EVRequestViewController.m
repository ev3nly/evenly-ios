//
//  EVRequestViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController.h"
#import "EVNavigationBarButton.h"
#import "EVBackButton.h"
#import "EVKeyboardTracker.h"
#import "EVGroupRequestDashboardViewController.h"

#import "EVRequest.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestTier.h"
#import "EVStory.h"
#import "EVValidator.h"

@interface EVRequestViewController ()

@property (nonatomic, strong) EVRequestWhoView *initialView;

@property (nonatomic, strong) EVExchangeHowMuchView *singleHowMuchView;
@property (nonatomic, strong) EVGroupRequestHowMuchView *groupHowMuchView;

@property (nonatomic, strong) EVExchangeWhatForView *singleWhatForView;
@property (nonatomic, strong) EVGroupRequestWhatForView *groupWhatForView;

@property (nonatomic) BOOL isGroupRequest;

@end

@implementation EVRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"New Request";
    }
    return self;
}

#pragma mark - Loading

- (void)loadContentViews {
    self.initialView = [[EVRequestWhoView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleHowMuchView = [[EVExchangeHowMuchView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.singleHowMuchView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.groupHowMuchView = [[EVGroupRequestHowMuchView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.groupHowMuchView.groupRequest = self.groupRequest;
    self.groupHowMuchView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleWhatForView = [[EVExchangeWhatForView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.singleWhatForView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.groupWhatForView = [[EVGroupRequestWhatForView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.groupWhatForView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (void)setUpReactions {
    // Handle the first screen: if it's a group request, and if not, if it has at least one recipient.
    RAC(self.isGroupRequest) = RACAble(self.initialView.requestSwitch.on);
    
    [RACAble(self.isGroupRequest) subscribeNext:^(NSNumber *isGroupRequest) {
        if (self.isGroupRequest) {
            [self.initialView.toField.textField setPlaceholder:[EVStringUtility groupToFieldPlaceholder]];
        } else {
            [self.initialView.toField.textField setPlaceholder:[EVStringUtility toFieldPlaceholder]];
        }
    }];
}

#pragma mark - Basic Interface

- (void)sendExchangeToServer {
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING REQUEST..."];
    
    if (self.isGroupRequest)
        [self sendGroupRequestToServer];
    else
        [self sendSingleRequestToServer];
}

- (void)sendSingleRequestToServer {
    [self setVisibilityForExchange:self.request];
    self.request.memo = self.singleWhatForView.descriptionField.text;
    EV_TRUNCATE_STRING(self.request.memo);
    
    [self.request saveWithSuccess:^{
        
        EVStory *story = [EVStory storyFromPendingExchange:self.request];
        story.publishedAt = [NSDate date];
        story.source = self.request;
        [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification object:nil userInfo:@{ @"story" : story }];
        [self sentRequestWithSuccessBlock:^{
            [self cancelButtonPress:nil];;
        }];
    } failure:^(NSError *error) {
        [self sentRequestWithError:error];
    }];}

- (void)sendGroupRequestToServer {
    self.groupRequest.title = self.groupWhatForView.nameField.text;
    self.groupRequest.memo = self.groupWhatForView.descriptionField.text;
    EV_TRUNCATE_STRING(self.groupRequest.title);
    EV_TRUNCATE_STRING(self.groupRequest.memo);
    
    [self setVisibilityForGroupRequest:self.groupRequest];
    DLog(@"Group request dictionary representation: %@", [self.groupRequest dictionaryRepresentation]);
    
    [EVGroupRequest createWithParams:[self.groupRequest dictionaryRepresentation]
                             success:^(EVObject *object) {
                                 EVGroupRequest *createdRequest = (EVGroupRequest *)object;
                                 [self sentRequestWithSuccessBlock:^{
                                     __block UIViewController *presenter = self.shouldDismissGrandparent ? self.presentingViewController.presentingViewController : self.presentingViewController;
                                     [presenter dismissViewControllerAnimated:YES
                                                                    completion:^{
                                                                        EVGroupRequestDashboardViewController *dashboardVC = [[EVGroupRequestDashboardViewController alloc] initWithGroupRequest:createdRequest];
                                                                        EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:dashboardVC];
                                                                        [presenter presentViewController:navController animated:YES completion:NULL];
                                                                    }];
                                 }];
                             } failure:^(NSError *error) {
                                 [self sentRequestWithError:error];
                             }];
}

- (void)sentRequestWithSuccessBlock:(EVStatusBarManagerCompletionBlock)successBlock {
    [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    [EVStatusBarManager sharedManager].duringSuccess = successBlock;
}

- (void)sentRequestWithError:(NSError *)error {
    DLog(@"failed to create %@", NSStringFromClass([self.request class]));
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    [[self rightButtonForPhase:self.phase] setEnabled:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]];
}

#pragma mark - Advancing

- (void)advanceToHowMuch {
    if (self.isGroupRequest)
        [self groupRequestAdvanceToHowMuch];
    else
        [self singleRequestAdvanceToHowMuch];
}

- (void)advanceToWhatFor {
    if (self.isGroupRequest)
        [self groupRequestAdvanceToWhatFor];
    else
        [self singleRequestAdvanceToWhatFor];
}

- (void)singleRequestAdvanceToHowMuch {
    self.request = [[EVRequest alloc] init];
    EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
    self.request.to = recipient;
    [self.singleHowMuchView.titleLabel setText:[NSString stringWithFormat:@"%@ owes me...", [recipient name]]];
    [self pushView:self.singleHowMuchView animated:YES];
    [self.singleWhatForView addSubview:self.privacySelector];
}

- (void)singleRequestAdvanceToWhatFor {
    self.request.amount = [EVStringUtility amountFromAmountString:self.singleHowMuchView.amountField.text];
    EVExchangeWhatForHeader *header = [EVExchangeWhatForHeader requestHeaderForPerson:self.request.to amount:self.request.amount];
    self.singleWhatForView.whatForHeader = header;
    [self pushView:self.singleWhatForView animated:YES];
}

- (void)groupRequestAdvanceToHowMuch {
    self.groupRequest = [[EVGroupRequest alloc] init];
    NSArray *sortedRecipients = [[self.initialView recipients] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] compare:[obj2 name]];
    }];
    self.groupRequest.initialMembers = sortedRecipients;
    self.groupHowMuchView.groupRequest = self.groupRequest;
    [self pushView:self.groupHowMuchView animated:YES];
    [self.groupWhatForView addSubview:self.privacySelector];
}

- (void)groupRequestAdvanceToWhatFor {
    self.groupRequest.tiers = self.groupHowMuchView.tiers;
    self.groupRequest.initialAssignments = self.groupHowMuchView.assignments;
    
    NSArray *tierPrices = [self.groupRequest.tiers map:^id(id object) {
        return [(EVGroupRequestTier*)object price];
    }];
    
    EVExchangeWhatForHeader *header = [EVExchangeWhatForHeader groupRequestHeaderForPeople:self.groupRequest.initialMembers
                                                                                   amounts:tierPrices];
    self.groupWhatForView.whatForHeader = header;
    [self pushView:self.groupWhatForView animated:YES];
}

#pragma mark - Validation

- (BOOL)shouldAdvanceToHowMuch {
    if (self.initialView.recipientCount == 0) {
        [self.initialView flashMessage:[EVStringUtility noRecipientsErrorMessage]
                               inFrame:self.initialView.toFieldFrame
                          withDuration:2.0];
        return NO;
    }
    else if ([self isGroupRequest] && [self.initialView recipientCount] <= 1) {
        [self.initialView flashMessage:[EVStringUtility notEnoughRecipientsErrorMessage]
                               inFrame:self.initialView.toFieldFrame
                          withDuration:2.0];
        return NO;
    }
    return YES;
}

- (BOOL)shouldAdvanceToWhatFor {
    if ([self isGroupRequest])
    {
        if ([self.groupHowMuchView showingMultipleOptions])
        {
            if ([self.groupHowMuchView isMissingAmount]) {
                [self.groupHowMuchView flashMessage:[EVStringUtility missingAmountErrorMessage]
                                            inFrame:self.groupHowMuchView.headerLabel.frame
                                       withDuration:1.0f];
                return NO;
            }
            else if ([self.groupHowMuchView hasUnassignedMembers]) {
                [self.groupHowMuchView flashMessage:[EVStringUtility assignFriendsErrorMessage]
                                            inFrame:self.groupHowMuchView.headerLabel.frame
                                       withDuration:2.0f];
                return NO;
            }
        }
        
        if ([self.groupHowMuchView hasTierBelowMinimum]) {
            [self.groupHowMuchView flashMessage:[EVStringUtility minimumRequestErrorMessage]
                                        inFrame:self.groupHowMuchView.headerLabel.frame
                                   withDuration:1.0f];
            return NO;
        }
    }
    else
    {
        float amount = [[EVStringUtility amountFromAmountString:self.singleHowMuchView.amountField.text] floatValue];
        BOOL okay = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT);
        if (!okay)
        {
            [self.singleHowMuchView.bigAmountView flashMinimumAmountLabel];
            return NO;
        }
    }
    return YES;
}

- (BOOL)shouldPerformAction {
    if ([self isGroupRequest]) {
        if (EV_IS_EMPTY_STRING(self.groupWhatForView.nameField.text)) {
            [self.groupWhatForView flashNoDescriptionMessage];
            return NO;
        }
    } else {
        if (EV_IS_EMPTY_STRING(self.singleWhatForView.descriptionField.text)) {
            [self.singleWhatForView flashNoDescriptionMessage];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Utility

- (void)setVisibilityForGroupRequest:(EVGroupRequest *)groupRequest {
    EVPrivacySetting privacySetting = [EVCIA me].privacySetting;
    groupRequest.visibility = [EVStringUtility stringForPrivacySetting:privacySetting];
}

- (NSString *)actionButtonText {
    return @"Request";
}

#pragma mark - Frames

- (CGRect)contentViewFrame {
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT);
}

@end
