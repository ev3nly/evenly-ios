//
//  EVViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVNavigationManager.h"

@interface EVViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation EVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTitleLabel];
}

- (void)loadTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [EVFont blackFontOfSize:21];
    self.titleLabel.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
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



@end
