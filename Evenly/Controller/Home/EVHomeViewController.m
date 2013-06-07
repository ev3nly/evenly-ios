//
//  EVHomeViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHomeViewController.h"
#import "EVUser.h"

@interface EVHomeViewController ()

@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) EVCIA *cia;

@end

@implementation EVHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Evenly";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [self loadBalanceLabel];
    [self loadRightBarButtonItem];
}

- (void)loadBalanceLabel {
    self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balanceLabel.font = [EVFont boldFontOfSize:21];
    self.balanceLabel.shadowColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.balanceLabel.shadowOffset = CGSizeMake(0, 1);
    self.balanceLabel.backgroundColor = [UIColor clearColor];
    self.balanceLabel.textColor = [UIColor whiteColor];
    [self.balanceLabel setText:[EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance]];
    [self.balanceLabel sizeToFit];
    self.navigationItem.titleView = self.balanceLabel;

    // RACAble prefers to operate on properties of self, so we can make the CIA a property of self
    // for a little syntactic sugar.
    self.cia = [EVCIA sharedInstance];
    [RACAble(self.cia.me.balance) subscribeNext:^(NSDecimalNumber *balance) {
        [self.balanceLabel setText:[EVStringUtility amountStringForAmount:[EVCIA sharedInstance].me.balance]];
        [self.balanceLabel sizeToFit];
    }];
    
}

- (void)loadRightBarButtonItem {
    UIImage *image = [UIImage imageNamed:@"Wallet"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 14, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self.masterViewController action:@selector(toggleRightPanel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated {
    DLog(@"View will disappear");
}

- (void)refreshButtonPress:(id)sender {
    [EVUser newsfeedWithSuccess:^(NSArray *newsfeed) {
        DLog(@"Newsfeed: %@", newsfeed);
    } failure:^(NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
