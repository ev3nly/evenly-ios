//
//  EVOnboardingViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVOnboardingViewController.h"
#import "EVSignInViewController.h"
#import "EVSignUpViewController.h"
#import "EVSetPINViewController.h"
#import "EVGettingStartedViewController.h"
#import "EVNavigationManager.h"
#import "EVFacebookManager.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

#define NUMBER_OF_SLIDES 6

#define CARD_SCALE (self.view.bounds.size.height/548.0)
#define TARGET_CARD_HEIGHT 450.0
#define CARD_HEIGHT ((int)(TARGET_CARD_HEIGHT * CARD_SCALE))
#define CARD_SIDE_BUFFER 16
#define CARD_PAGE_CONTROL_BUFER 10
#define SIGN_IN_LABEL_BOTTOM_BUFFER 16
#define SIGN_IN_LABEL_FONT_SIZE 14

#define LOGO_LENGTH 140
#define LOGO_TEXT_BUFFER 20
#define PICTURE_BOTTOM_BUFFER 20
#define SMALL_SCREEN_REWARDS_PICTURE_BOTTOM_BUFFER 70
#define TITLE_TOP_BUFFER 36
#define TITLE_SUBTITLE_BUFFER 4
#define MAX_TEXT_WIDTH 272

#define PICTURE_SCALE_CONSTANT 140.0
#define PICTURE_SCALE ((self.view.bounds.size.height-PICTURE_SCALE_CONSTANT)/(548.0-PICTURE_SCALE_CONSTANT))

#define SIGNUP_LABEL_Y_ORIGIN 180
#define BUTTON_LEFT_MARGIN 30
#define SIGNUP_LABEL_BUTTON_BUFFER 20
#define OR_LABEL_BUTTON_BUFFER 10

#define FACEBOOK_F_TITLE_BUFFER 20
#define FACEBOOK_WONT_POST_BUFFER ([EVUtilities deviceHasTallScreen] ? 20 : 12)
#define F_ICON_TAG 4402
#define ROUNDED_CARD_TAG 4205

#define SMALL_SCREEN_PEOPLE_IMAGE_BUFFER 14

#define FACEBOOK_BUTTON_LOADING_Y_OFFSET ([EVUtilities deviceHasTallScreen] ? -60 : -46)

@interface EVOnboardingViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *onboardingViews;
@property (nonatomic, strong) UIButton *signInLabel;
@property (nonatomic, strong) UIButton *facebookButton;

@end

@implementation EVOnboardingViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = EV_RGB_COLOR(27, 34, 38);
    [self loadScrollView];
    [self loadPageControl];
    [self loadSignInLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = [self scrollViewFrame];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * NUMBER_OF_SLIDES, self.scrollView.bounds.size.height);
    self.pageControl.frame = [self pageControlFrame];
    self.signInLabel.frame = [self signInLabelFrame];
    [self loadOnboardingViews];
}

#pragma mark - View Loading

- (void)loadScrollView {
    self.scrollView = [UIScrollView new];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

- (void)loadPageControl {
    self.pageControl = [UIPageControl new];
    self.pageControl.numberOfPages = NUMBER_OF_SLIDES;
    self.pageControl.enabled = NO;
    [self.view addSubview:self.pageControl];
}

- (void)loadOnboardingViews {
    [self.scrollView removeAllSubviews];
    self.onboardingViews = @[[self firstOnboardView],
                             [self secondOnboardView],
                             [self thirdOnboardView],
                             [self fourthOnboardView],
                             [self fifthOnboardView],
                             [self sixthOnboardView]];
    for (UIView *view in self.onboardingViews) {
        view.frame = [self frameForOnboardingViewIndex:[self.onboardingViews indexOfObject:view]];
        [self.scrollView addSubview:view];
    }
}

- (void)loadSignInLabel {
    self.signInLabel = [UIButton new];
    [self.signInLabel addTarget:self action:@selector(signInLabelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.signInLabel setTitle:@"Already have an account? Sign in." forState:UIControlStateNormal];
    [self.signInLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signInLabel setTitleColor:[EVColor lightLabelColor] forState:UIControlStateHighlighted];
    self.signInLabel.titleLabel.font = [EVFont romanFontOfSize:SIGN_IN_LABEL_FONT_SIZE];
    [self.view addSubview:self.signInLabel];
}

#pragma mark - Onboard Views

- (UIView *)firstOnboardView {
    UIView *view = [UIView new];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Don't Get Mad.   Get Evenly";
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [EVFont romanFontOfSize:34];
    
    float totalHeight = LOGO_LENGTH + LOGO_TEXT_BUFFER + [self sizeForLabel:label].height;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[EVImages bigIcon]];
    logo.frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - LOGO_LENGTH/2,
                            CGRectGetMidY(self.scrollView.bounds) - totalHeight/2,
                            LOGO_LENGTH,
                            LOGO_LENGTH);
    logo.layer.masksToBounds = YES;
    label.frame = CGRectMake(0,
                             CGRectGetMaxY(logo.frame) + LOGO_TEXT_BUFFER,
                             self.scrollView.bounds.size.width,
                             [self sizeForLabel:label].height);
    
    [logo align];
    [label align];
    
    [view addSubview:logo];
    [view addSubview:label];
    return view;
}

- (UIView *)secondOnboardView {
    NSString *title = @"Pay anyone, safely";
    NSString *description = @"Cash is a pain. Add a card to your Evenly wallet and pay anyone, anywhere, anytime.";
    UIImage *image = [EVImages onboardCard1];
    return [self cardViewWithTitle:title description:description image:image imageOffset:CGPointZero shouldScale:YES];
}

- (UIView *)thirdOnboardView {
    NSString *title = @"Win Cash Rewards";
    NSString *description = @"After every payment, you can play the Evenly Rewards game and win up to $10 in cash back.";
    UIImage *image = [EVImages onboardCard4];
    float bottomBuffer = [EVUtilities deviceHasTallScreen] ? PICTURE_BOTTOM_BUFFER : SMALL_SCREEN_REWARDS_PICTURE_BOTTOM_BUFFER;
    return [self cardViewWithTitle:title description:description image:image imageOffset:CGPointMake(0, bottomBuffer) shouldScale:NO];
}

- (UIView *)fourthOnboardView {
    NSString *title = @"Deposit, instantly";
    NSString *description = @"With one tap, securely deposit the cash in your Evenly wallet into any bank account.";
    UIImage *image = [EVImages onboardCard3];
    return [self cardViewWithTitle:title description:description image:image imageOffset:CGPointZero shouldScale:YES];
}

- (UIView *)fifthOnboardView {
    NSString *title = @"Collect money, effortlessly";
    NSString *description = @"Stop hassling friends. Send a request and we'll remind your friends until they pay you back.";
    UIImage *image = [EVImages onboardCard2];
    return [self cardViewWithTitle:title description:description image:image imageOffset:CGPointMake(0, 2) shouldScale:YES];
}

- (UIView *)sixthOnboardView {
    NSString *title = @"Fun, Social, & Free";
    NSString *description = @"There are no transaction fees. Connect with Facebook and share the experience with your friends.";
    UIView *view = [self cardViewWithTitle:title description:description image:nil imageOffset:CGPointZero shouldScale:NO];
    
    self.facebookButton = [self configuredFacebookButton];
    UILabel *wontPostLabel = [self descriptionLabelWithText:@"We will never post to your wall\nwithout your permission"];
    wontPostLabel.font = [EVFont defaultFontOfSize:15];
    
    UIImageView *peopleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"people"]];
    
    [view addSubview:self.facebookButton];
    [view addSubview:wontPostLabel];
    
    for (UIView *subview in view.subviews) {
        if ([subview viewWithTag:ROUNDED_CARD_TAG])
            [[subview viewWithTag:ROUNDED_CARD_TAG] addSubview:peopleImage];
    }
    
    float smallScreenBuffer = (self.view.bounds.size.height > 480) ? 0 : SMALL_SCREEN_PEOPLE_IMAGE_BUFFER;
    
    self.facebookButton.frame = CGRectMake(BUTTON_LEFT_MARGIN,
                                           SIGNUP_LABEL_Y_ORIGIN * CARD_SCALE,
                                           self.scrollView.bounds.size.width - BUTTON_LEFT_MARGIN*2,
                                           [EVImages facebookButton].size.height);
    wontPostLabel.frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - [self sizeForLabel:wontPostLabel].width/2,
                                     CGRectGetMaxY(self.facebookButton.frame) + FACEBOOK_WONT_POST_BUFFER,
                                     [self sizeForLabel:wontPostLabel].width,
                                     [self sizeForLabel:wontPostLabel].height);
    peopleImage.frame = CGRectMake((peopleImage.superview.bounds.size.width - peopleImage.image.size.width)/2,
                                   peopleImage.superview.bounds.size.height - peopleImage.image.size.height + smallScreenBuffer,
                                   peopleImage.image.size.width,
                                   peopleImage.image.size.height);
    
    if ([self.facebookButton viewWithTag:F_ICON_TAG]) {
        float totalWidth = [EVImages facebookButton].size.width + FACEBOOK_F_TITLE_BUFFER + self.facebookButton.titleLabel.bounds.size.width;
        [self.facebookButton viewWithTag:F_ICON_TAG].frame = CGRectMake(CGRectGetMidX(self.facebookButton.bounds) - totalWidth/2,
                                                                        CGRectGetMidY(self.facebookButton.bounds) - [EVImages facebookFIcon].size.height/2,
                                                                        [EVImages facebookFIcon].size.width,
                                                                        [EVImages facebookFIcon].size.height);
    }
    
    return view;
}

#pragma mark - View Helper Methods

- (UIView *)cardViewWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image imageOffset:(CGPoint)imageOffset shouldScale:(BOOL)shouldScale {
    UIView *view = [UIView new];
    [view addSubview:[self roundedBackgroundCardView]];
    
    float imageScale = shouldScale ? PICTURE_SCALE : 1;
    
    UILabel *titleLabel = [self titleLabelWithText:title];
    UILabel *descriptionLabel = [self descriptionLabelWithText:description];
    UIImageView *picture = [[UIImageView alloc] initWithImage:image];
    
    titleLabel.frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - [self sizeForLabel:titleLabel].width/2,
                                  TITLE_TOP_BUFFER,
                                  [self sizeForLabel:titleLabel].width,
                                  [self sizeForLabel:titleLabel].height);
    descriptionLabel.frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - [self sizeForLabel:descriptionLabel].width/2,
                                        CGRectGetMaxY(titleLabel.frame) + TITLE_SUBTITLE_BUFFER,
                                        [self sizeForLabel:descriptionLabel].width,
                                        [self sizeForLabel:descriptionLabel].height);
    picture.frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - (image.size.width * imageScale)/2 + imageOffset.x,
                               self.scrollView.bounds.size.height - PICTURE_BOTTOM_BUFFER - (image.size.height * imageScale) + imageOffset.y,
                               image.size.width * imageScale,
                               image.size.height * imageScale);
    
    [view addSubview:titleLabel];
    [view addSubview:picture];
    [view addSubview:descriptionLabel];
    
    return view;
}

- (UILabel *)titleLabelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [EVColor darkLabelColor];
    label.font = [EVFont blackFontOfSize:21];
    return label;
}

- (UILabel *)descriptionLabelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.numberOfLines = 3;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [EVColor lightLabelColor];
    label.font = [EVFont defaultFontOfSize:17];
    return label;
}

- (UIView *)roundedBackgroundCardView {
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(CARD_SIDE_BUFFER,
                                                            CARD_SIDE_BUFFER,
                                                            self.scrollView.bounds.size.width - CARD_SIDE_BUFFER*2,
                                                            CARD_HEIGHT)];
    card.backgroundColor = [UIColor whiteColor];
    UIView *baigeBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, card.bounds.size.width, CARD_HEIGHT/3)];
    baigeBackground.backgroundColor = EV_RGB_COLOR(246, 245, 242);
    card.layer.cornerRadius = 10.0;
    card.clipsToBounds = YES;
    card.tag = ROUNDED_CARD_TAG;
    return card;
}

- (UIButton *)configuredFacebookButton {
    UIButton *button = [UIButton new];
    [button setBackgroundImage:[EVImages facebookButton] forState:UIControlStateNormal];
    [button setBackgroundImage:[EVImages facebookButtonPress] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(facebookButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Continue" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [EVFont blackFontOfSize:16];
    
    float totalWidth = [EVImages facebookButton].size.width + FACEBOOK_F_TITLE_BUFFER + button.titleLabel.bounds.size.width;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, (totalWidth - button.titleLabel.bounds.size.width), 0, 0)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[EVImages facebookFIcon]];
    imageView.tag = F_ICON_TAG;
    [button addSubview:imageView];
    
    return button;
}

- (CGSize)sizeForLabel:(UILabel *)label {
    return [label.text sizeWithFont:label.font
                  constrainedToSize:CGSizeMake(MAX_TEXT_WIDTH, 1000)
                      lineBreakMode:label.lineBreakMode];
}

#pragma mark - Button Handling

- (void)facebookButtonTapped {
    [EVFacebookManager loadMeWithCompletion:^(NSDictionary *userDict) {
        NSString *avatarUrlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=176&height=176", [userDict objectForKey:@"id"]];
        EVUser *newUser = [EVUser new];
        newUser.name = [userDict objectForKey:@"name"];
        newUser.email = [userDict objectForKey:@"email"];
        newUser.avatarURL = [NSURL URLWithString:avatarUrlString];
        [newUser loadAvatar];
        
        EVSignUpViewController *signUpController = [[EVSignUpViewController alloc] initWithSignUpSuccess:^{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{                
                EVGettingStartedViewController *controller = [[EVGettingStartedViewController alloc] initWithType:EVGettingStartedTypeAll];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                [[EVNavigationManager sharedManager].masterViewController presentViewController:navController animated:YES completion:nil];
            }];
        } user:newUser];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signUpController];
        [self presentViewController:navController animated:YES completion:nil];
    } failure:^(NSError *error) {
        [[UIAlertView alertViewWithTitle:@"Error"
                                  message:@"Sorry! We couldn't connect with Facebook right now. Please make sure you're using the right username and password and try again!"
                        cancelButtonTitle:@"OK"] show];
    }];
}

- (void)emailButtonTapped {
    EVSignUpViewController *signUpController = [[EVSignUpViewController alloc] initWithSignUpSuccess:^{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            EVSetPINViewController *pinController = [[EVSetPINViewController alloc] initWithNibName:nil bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinController];
            [[EVNavigationManager sharedManager].masterViewController presentViewController:navController animated:YES completion:nil];
        }];
    }];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signUpController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)signInLabelTapped {
    EVSignInViewController *signInViewController = [[EVSignInViewController alloc] initWithAuthenticationSuccess:^{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    signInViewController.canDismissManually = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x / scrollView.bounds.size.width);
}

#pragma mark - Frames

- (CGRect)scrollViewFrame {
    return CGRectMake(0,
                      0,
                      self.view.bounds.size.width,
                      CARD_HEIGHT + CARD_SIDE_BUFFER);
}

- (CGRect)pageControlFrame {
    [self.pageControl sizeToFit];
    return CGRectMake(0,
                      CGRectGetMaxY(self.scrollView.frame),
                      self.view.bounds.size.width,
                      self.pageControl.bounds.size.height);
}

- (CGRect)frameForOnboardingViewIndex:(int)index {
    return CGRectMake(index * self.scrollView.bounds.size.width,
                      0,
                      self.scrollView.bounds.size.width,
                      self.scrollView.bounds.size.height);
}

- (CGRect)signInLabelFrame {
    return CGRectMake(0,
                      self.view.bounds.size.height - [self bottomSectionHeight]/3 - SIGN_IN_LABEL_BOTTOM_BUFFER,
                      self.view.bounds.size.width,
                      40);
}

- (float)bottomSectionHeight {
    return (self.view.bounds.size.height - CGRectGetMaxY(self.scrollView.frame));
}

@end
