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

#define HEADER_FOOTER_DEFAULT_HEIGHT 10
#define STATUS_BAR_BLUR_BACKGROUND_EXTENSION 1
#define CANCEL_IMAGE_WIDTH_PADDING 20
#define WALLET_IMAGE_WIDTH_PADDING 14

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
    if (![EVUtilities userHasIOS7])
        return 0;
    
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
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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

    CGSize insetSize = CGSizeMake(EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - closeImage.size.width,
                                  (EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - closeImage.size.height)/2);
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake(insetSize.height, 0, insetSize.height, insetSize.width);

    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.showsTouchWhenHighlighted = YES;
    
    if (![EVUtilities userHasIOS7]) {
        cancelButton.frame = CGRectMake(0, 0, closeImage.size.width + CANCEL_IMAGE_WIDTH_PADDING, closeImage.size.height);
        cancelButton.imageEdgeInsets = EV_VIEW_CONTROLLER_BAR_BUTTON_IMAGE_INSET;
    }
    return cancelButton;
}

- (void)loadWalletBarButtonItem {
    UIImage *image = [UIImage imageNamed:@"Wallet"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT, EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT)];
    [button setImage:image forState:UIControlStateNormal];
    
    CGSize insetSize = CGSizeMake(EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - image.size.width, (EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT - image.size.height)/2);
    button.imageEdgeInsets = UIEdgeInsetsMake(insetSize.height, insetSize.width, insetSize.height, 0);

    [button addTarget:self.masterViewController action:@selector(toggleRightPanel:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.showsTouchWhenHighlighted = YES;
    
    if (![EVUtilities userHasIOS7]) {
        button.frame = CGRectMake(0, 0, image.size.width + WALLET_IMAGE_WIDTH_PADDING, image.size.height);
        button.imageEdgeInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)loadStatusBarBackground {
    if ([EVUtilities userHasIOS7]) {
        UIView *navStatusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                  0,
                                                                                  self.view.bounds.size.width,
                                                                                  [UIApplication sharedApplication].statusBarFrame.size.height)];
        navStatusBarBackground.backgroundColor = [EVColor navBarOverlayColor];
        navStatusBarBackground.alpha = 0.5;
        [self.view addSubview:navStatusBarBackground];
        
        AMBlurView *blurView = [AMBlurView new];
        blurView.frame = CGRectMake(0,
                                    0,
                                    self.view.bounds.size.width,
                                    [UIApplication sharedApplication].statusBarFrame.size.height + STATUS_BAR_BLUR_BACKGROUND_EXTENSION);
        blurView.blurTintColor = [EVColor blueColor];
        [self.view addSubview:blurView];
    }
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

#pragma mark - Defaults

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain)
        return 0;
    return HEADER_FOOTER_DEFAULT_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain)
        return 0;
    return HEADER_FOOTER_DEFAULT_HEIGHT;
}

@end
