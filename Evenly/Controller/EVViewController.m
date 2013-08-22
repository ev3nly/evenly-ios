//
//  EVViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVNavigationManager.h"
#import "EVBackButton.h"

#import "AMBlurView.h"

@interface EVViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    [self.swipeGestureRecognizer removeTarget:nil action:NULL];
    self.swipeGestureRecognizer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognized:)];
    [self.swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    if (self.navigationController.viewControllers.count > 1 && self.navigationController.viewControllers.lastObject == self)
    {
        [self loadBackButton];
        [self.view addGestureRecognizer:self.swipeGestureRecognizer];
    }
    
    self.view.backgroundColor = [EVColor creamColor];
    
    [self loadTitleLabel];    
}

- (float)totalBarHeight {
    float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    float navigationBarHeight = self.navigationController ? self.navigationController.navigationBar.bounds.size.height : 0;
    return statusBarHeight + navigationBarHeight;
}

- (void)loadTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [EVFont blackFontOfSize:21];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    [self.navigationItem setTitleView:self.titleLabel];
}


- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)loadBackButton {
    UIButton *button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)swipeGestureRecognized:(UISwipeGestureRecognizer *)recognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)defaultCancelButton {
    UIImage *closeImage = [EVImages navBarCancelButton];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT)];
    [cancelButton setImage:closeImage forState:UIControlStateNormal];

    CGSize insetSize = CGSizeMake(EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - closeImage.size.width, (EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - closeImage.size.height)/2);
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(insetSize.height, 0, insetSize.height, insetSize.width)];

    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.showsTouchWhenHighlighted = YES;
    return cancelButton;
}

- (void)loadWalletBarButtonItem {
    UIImage *image = [UIImage imageNamed:@"Wallet"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT)];
    [button setImage:image forState:UIControlStateNormal];
    
    CGSize insetSize = CGSizeMake(EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - image.size.width, (EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - image.size.height)/2);
    [button setImageEdgeInsets:UIEdgeInsetsMake(insetSize.height, insetSize.width, insetSize.height, 0)];

    [button addTarget:self.masterViewController action:@selector(toggleRightPanel:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)loadStatusBarBackground {
    UIView *navStatusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    navStatusBarBackground.backgroundColor = EV_RGB_COLOR(0, 112, 207);
    navStatusBarBackground.alpha = 0.5;
    [self.view addSubview:navStatusBarBackground];
    
    AMBlurView *blurView = [AMBlurView new];
    blurView.frame = CGRectMake(0, 0, 320, 21);
    blurView.blurTintColor = [EVColor blueColor];
    [self.view addSubview:blurView];
}

- (void)cancelButtonPress:(id)sender {
    if (self.shouldDismissGrandparent)
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    else
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
