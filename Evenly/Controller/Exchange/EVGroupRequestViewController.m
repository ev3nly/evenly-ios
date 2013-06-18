//
//  EVGroupRequestViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestViewController.h"
#import "EVPageView.h"

@interface EVGroupRequestViewController ()

@property (nonatomic, strong) EVPagingScrollView *pagingScrollView;

@end

@implementation EVGroupRequestViewController

@synthesize exchange;

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
    
    self.pagingScrollView = [[EVPagingScrollView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height)
                                                            direction:EVPagingScrollViewDirectionHorizontal];
    self.pagingScrollView.dataSource = self;
    self.pagingScrollView.pagingDelegate = self;
    self.pagingScrollView.lookAhead = 2;
    self.pagingScrollView.lookBehind = 2;
    self.pagingScrollView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.pagingScrollView.clipsToBounds = NO;
    [self.view addSubview:self.pagingScrollView];    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.pagingScrollView reloadData];
}

- (NSUInteger)numberOfPagesInPagingScrollView:(EVPagingScrollView *)scrollView {
    return 3;
}

- (EVPageView *)pagingScrollView:(EVPagingScrollView *)scrollView pageViewForIndex:(NSUInteger)index {
    EVPageView *pageView = [scrollView dequeueReusableViewWithIdentifier:@"pageView"];
    if (!pageView) {
        pageView = [[EVPageView alloc] initWithReuseIdentifier:@"pageView"];
        pageView.autoresizesSubviews = YES;
    }
    [[pageView viewWithTag:303] removeFromSuperview];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, pageView.frame.size.width - 10, pageView.frame.size.height - 10)];
    view.backgroundColor = [UIColor grayColor];
    view.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    view.tag = 303;
    [pageView addSubview:view];
    
    [pageView setBackgroundColor:[UIColor cyanColor]];
    return pageView;
}


@end
