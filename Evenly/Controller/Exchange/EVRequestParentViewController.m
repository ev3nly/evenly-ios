//
//  EVRequestParentViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestParentViewController.h"
#import "EVNavigationBarButton.h"
#import "EVPageControl.h"
#import "EVCharge.h"

#import "EVRequestViewController.h"
#import "EVGroupRequestViewController.h"

@interface EVRequestParentViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *hiddenTextField;
@property (nonatomic, strong) EVNavigationBarButton *requestButton;

- (void)loadRequestSwitch;
- (void)loadContainerView;
- (void)loadFriendRequestController;
- (void)loadGroupRequestController;

@end

@implementation EVRequestParentViewController

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
    [self loadRequestSwitch];
    [self loadRequestButton];
    [self loadHiddenTextField];
    [self loadPrivacySelector];
    [self loadContainerView];

    [self loadFriendRequestController];
    [self loadGroupRequestController];
    
    [self setUpReactions];
}

- (void)loadRequestSwitch {
    UIView *requestSwitchBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               [self requestSwitchSize].width,
                                                                               [self requestSwitchSize].height)];
    requestSwitchBackground.backgroundColor = [EVColor creamColor];
    [self.view addSubview:requestSwitchBackground];
    
    self.requestSwitch = [[EVRequestSwitch alloc] initWithFrame:[self requestSwitchFrame]];
    self.requestSwitch.delegate = self;
    self.requestSwitch.panningEnabled = NO;
    [self.requestSwitch addTarget:self action:@selector(requestSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [requestSwitchBackground addSubview:self.requestSwitch];
}

- (void)loadRequestButton {
    self.requestButton = [[EVNavigationBarButton alloc] initWithTitle:@"Request"];
    [self.requestButton addTarget:self action:@selector(requestButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.requestButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.requestButton];    
}

- (void)loadContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.requestSwitch.frame),
                                                                  self.view.frame.size.width,
                                                                  CGRectGetMinY(self.privacySelector.frame) - CGRectGetMaxY(self.requestSwitch.frame))];
//    self.containerView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.containerView.autoresizesSubviews = YES;
    [self.view addSubview:self.containerView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (void)loadHiddenTextField {
    self.hiddenTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.hiddenTextField]; 
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

- (void)loadFriendRequestController {
    self.friendRequestController = [[EVRequestViewController alloc] init];
    [self.friendRequestController.view setFrame:self.containerView.bounds];
    [self addChildViewController:self.friendRequestController];
    [self.containerView addSubview:self.friendRequestController.view];
    self.activeViewController = self.friendRequestController;    
}

- (void)setUpReactions {
    [RACAble(self.activeViewController.exchange.isValid) subscribeNext:^(NSNumber *boolNumber) {
        DLog(@"Is valid: %@", [boolNumber boolValue] ? @"YES" : @"NO");
        self.requestButton.enabled = [boolNumber boolValue];
    }];
}

- (void)loadGroupRequestController {
    self.groupRequestController = [[EVGroupRequestViewController alloc] init];
    [self.groupRequestController.view setFrame:self.containerView.bounds];
    [self addChildViewController:self.groupRequestController];
    [self.containerView addSubview:self.groupRequestController.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setActiveViewController:self.activeViewController animated:animated];
}

- (void)setActiveViewController:(EVViewController *)viewController animated:(BOOL)animated {
    EVViewController<EVExchangeCreator>  *fromViewController, *toViewController;
    UIViewAnimationOptions options;
    if (viewController == self.friendRequestController)
    {
        
        fromViewController = self.groupRequestController;
        toViewController = self.friendRequestController;
        options = UIViewAnimationOptionTransitionFlipFromLeft;
    }
    else // if (viewController == self.friendRequestController)
    {
        fromViewController = self.friendRequestController;
        toViewController = self.groupRequestController;
        options = UIViewAnimationOptionTransitionFlipFromRight;
    }
        [self.hiddenTextField becomeFirstResponder];
    
//    [UIView transitionWithView:self.containerView
//                      duration:0.5f
//                       options:options animations:^{
//                           [fromViewController.view removeFromSuperview];
//                           [self.containerView addSubview:toViewController.view];
//                       } completion:^(BOOL finished) {
//                       }];
    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0.5f
                               options:options
                            animations:^{
//                                toViewController.view.frame = self.containerView.bounds;
                            } completion:^(BOOL finished) {
                                DLog(@"Finished? %@", (finished ? @"YES" : @"NO"));
                                self.activeViewController = toViewController;
                            }];
}

- (CGSize)requestSwitchSize {
    return CGSizeMake(self.view.frame.size.width, 50.0);
}


- (CGRect)requestSwitchFrame {
    return CGRectMake(10, 7, 300, 35);
}

#pragma mark - EVSwitchDelegate

- (void)switchControl:(EVSwitch *)switchControl willChangeStateTo:(BOOL)onOff animationDuration:(NSTimeInterval)duration {
    if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
//            float percentage = (onOff ? 1.0 : 0.0);
//            [self positionSubviewsForPercentage:percentage];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(onOff ? self.skipButton : self.completeExchangeButton)];
        }];
    }
}

- (void)switchControl:(EVSwitch *)switchControl didChangeStateTo:(BOOL)onOff {
//    if (onOff == NO) {
//        [self.formView.toField becomeFirstResponder];
//    } else {
//        [self.groupChargeForm.toField becomeFirstResponder];
//    }
}




/* SAVING THIS FOR LATER */


//- (void)loadGroupFormView {
//    self.groupChargeForm = [[EVGroupRequestFormView alloc] initWithFrame:[self formViewFrame]];
//    [self.groupChargeForm setOrigin:CGPointMake(-self.groupChargeForm.frame.size.width, self.groupChargeForm.frame.origin.y)];
//    
//    CGFloat margin = GROUP_CHARGE_FORM_INFORMATIONAL_LABEL_MARGIN;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin,
//                                                               CGRectGetMaxY(self.groupChargeForm.toField.frame),
//                                                               self.groupChargeForm.frame.size.width - 2*margin,
//                                                               self.groupChargeForm.frame.size.height - CGRectGetMaxY(self.groupChargeForm.toField.frame) - self.requestSwitch.frame.size.height - margin)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [EVFont blackFontOfSize:16];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [EVColor newsfeedTextColor];
//    label.text = @"Add names now or add them later in the dashboard.";
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.groupChargeForm addSubview:label];
//    
//    [self.view insertSubview:self.groupChargeForm belowSubview:self.privacySelector];
//}


#pragma mark - Actions

- (void)requestButtonPress:(id)sender {
    
}

- (void)requestSwitchChanged:(EVSwitch *)theSwitch {
    if ((EVRequestType)[theSwitch isOn] == EVRequestTypeFriend) {
        [self setActiveViewController:self.friendRequestController animated:YES];
    } else {
        [self setActiveViewController:self.groupRequestController animated:YES];
    }
}

@end
