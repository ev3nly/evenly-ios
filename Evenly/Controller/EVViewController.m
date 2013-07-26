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
    [self.navigationController.view removeGestureRecognizers];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognized:)];
    [self.swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    if (self.navigationController.viewControllers.count > 1 && self.navigationController.viewControllers.lastObject == self)
    {
        [self loadBackButton];
        [self.navigationController.view addGestureRecognizer:self.swipeGestureRecognizer];
    }
    
    self.view.backgroundColor = [EVColor creamColor];
    
    [self loadTitleLabel];
}

- (void)loadTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [EVFont blackFontOfSize:21];
//    self.titleLabel.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
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

@end
