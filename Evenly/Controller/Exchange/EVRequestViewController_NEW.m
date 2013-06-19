//
//  EVRequestViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController_NEW.h"
#import "EVNavigationBarButton.h"
#import "EVPageControl.h"
#import "EVPrivacySelectorView.h"
#import "EVBackButton.h"

#import "EVAutocompleteTableViewDataSource.h"
#import "EVUserAutocompletionCell.h"
#import "EVKeyboardTracker.h"

#import "ABContactsHelper.h"

#define TITLE_PAGE_CONTROL_Y_OFFSET 5.0

@interface EVRequestViewController_NEW ()

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVBackButton *backButton;
@property (nonatomic, strong) EVNavigationBarButton *nextButton;
@property (nonatomic, strong) EVNavigationBarButton *requestButton;
@property (nonatomic, strong) EVPageControl *pageControl;
@property (nonatomic, strong) EVPrivacySelectorView *privacySelector;

@property (nonatomic, strong) UITableView *autocompleteTableView;
@property (nonatomic, strong) EVAutocompleteTableViewDataSource *autocompleteDataSource;

@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;

@property (nonatomic) BOOL isGroupRequest;
@property (nonatomic) BOOL hasRecipients;
@property (nonatomic) BOOL canGoToHowMuchPhase;

- (void)loadNavigationButtons;
- (void)loadPageControl;
- (void)loadPrivacySelector;
- (void)loadContentViews;
- (void)loadAutocomplete;

- (UIButton *)leftButtonForPhase:(EVRequestPhase)phase;
- (UIButton *)rightButtonForPhase:(EVRequestPhase)phase;

@end

@implementation EVRequestViewController_NEW

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Request";
        self.phase = EVRequestPhaseWho;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigationButtons];
    [self loadPageControl];
//    [self setUpNavBar];

    [self loadPrivacySelector];
    [self loadContentViews];
    [self loadAutocomplete];
    
    [self setUpReactions];
}

- (void)loadNavigationButtons {
    
    NSMutableArray *left = [NSMutableArray array];
    NSMutableArray *right = [NSMutableArray array];
    UIButton *button;
    
    // Left buttons    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [button addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [left addObject:button];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button] animated:NO];

    button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [left addObject:button];

    button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [left addObject:button];

    // Right buttons
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button] animated:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    button = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Request"];
    [button addTarget:self action:@selector(requestButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    
    self.leftButtons = [NSArray arrayWithArray:left];
    self.rightButtons = [NSArray arrayWithArray:right];
}

- (void)loadPageControl {
    self.pageControl = [[EVPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl sizeToFit];
    [self.pageControl setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width / 2.0,
                                            self.titleLabel.frame.size.height + 5.0)];
    [self.navigationController.navigationBar addSubview:self.pageControl];
    CGFloat positionAdjustment = -TITLE_PAGE_CONTROL_Y_OFFSET;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:positionAdjustment
                                                                  forBarMetrics:UIBarMetricsDefault];
    CGRect rect = self.titleLabel.frame;
    rect.origin.y += positionAdjustment;
    [self.navigationItem.titleView setFrame:rect];
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

- (void)loadContentViews {
    self.initialView = [[EVRequestInitialView alloc] initWithFrame:[self.view bounds]];
    self.initialView.backgroundColor = [UIColor clearColor];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleAmountView = [[EVRequestSingleAmountView alloc] initWithFrame:[self contentViewFrame]];
    self.singleAmountView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.detailsView = [[EVRequestDetailsView alloc] initWithFrame:[self.view bounds]];
    self.detailsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;    
    [self.detailsView addSubview:self.privacySelector];
    
    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (CGRect)contentViewFrame {
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT);
}

- (void)loadAutocomplete {
    self.autocompleteDataSource = [[EVAutocompleteTableViewDataSource alloc] init];
    

    self.autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.autocompleteTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self.autocompleteDataSource;
    self.autocompleteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.autocompleteTableView registerClass:[EVUserAutocompletionCell class]
                      forCellReuseIdentifier:@"userAutocomplete"];
    self.autocompleteTableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    self.autocompleteDataSource.tableView = self.autocompleteTableView;
    self.autocompleteDataSource.textField = self.initialView.toField.textField;
    [self.autocompleteDataSource setUpReactions];
    
    [self.initialView setAutocompleteTableView:self.autocompleteTableView];
    [self.autocompleteTableView setHidden:YES];
}

- (void)setUpReactions {

    RAC(self.isGroupRequest) = RACAble(self.initialView.requestSwitch.on);
    
    [RACAble(self.isGroupRequest) subscribeNext:^(NSNumber *isGroupRequest) {
        if ([isGroupRequest boolValue]) {
            [[self rightButtonForPhase:EVRequestPhaseWho] setEnabled:YES];
        } else {
            [[self rightButtonForPhase:EVRequestPhaseWho] setEnabled:(BOOL)self.initialView.recipientCount];
        }
    }];
    
    [RACAble(self.initialView.recipientCount) subscribeNext:^(NSNumber *hasRecipients) {
        if (self.isGroupRequest) {
            [[self rightButtonForPhase:EVRequestPhaseWho] setEnabled:YES];
        } else {
            [[self rightButtonForPhase:EVRequestPhaseWho] setEnabled:[hasRecipients boolValue]];
        }
    }];
}

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)backButtonPress:(id)sender {
    [self popViewAnimated:YES];
    self.phase--;
    [self setUpNavBar];
}

- (void)nextButtonPress:(id)sender {
    if (self.phase == EVRequestPhaseWho)
    {
        if (!self.isGroupRequest)
        {
            EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
            [self.singleAmountView.titleLabel setText:[NSString stringWithFormat:@"%@ owes me", [recipient name]]];
            [self pushView:self.singleAmountView animated:YES];
        }
        else
        {
            
        }
        self.phase = EVRequestPhaseHowMuch;
    }
    else if (self.phase == EVRequestPhaseHowMuch)
    {
        NSString *title = [NSString stringWithFormat:@"Zach Abrams owes me %@", self.singleAmountView.amountField.text];
        [self.detailsView.titleLabel setText:title];
        [self pushView:self.detailsView animated:YES];
        self.phase = EVRequestPhaseWhatFor;
    }
    [self setUpNavBar];
}

- (void)setUpNavBar {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]] animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self rightButtonForPhase:self.phase]] animated:YES];
    [self.pageControl setCurrentPage:self.phase];
}

- (UIButton *)leftButtonForPhase:(EVRequestPhase)phase {
    return [self.leftButtons objectAtIndex:phase];
}

- (UIButton *)rightButtonForPhase:(EVRequestPhase)phase {
    return [self.rightButtons objectAtIndex:phase];
}

#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.autocompleteTableView) {
        [self.initialView.toField.textField resignFirstResponder];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id contact = [self.autocompleteDataSource.suggestions objectAtIndex:indexPath.row];
    if ([contact isKindOfClass:[ABContact class]]) {
        NSString *emailAddress = [[contact emailArray] objectAtIndex:0];
		EVContact *toContact = [[EVContact alloc] init];
		toContact.email = emailAddress;
        toContact.name = [contact contactName];
        contact = toContact;
    }
    [self.initialView addContact:contact];
    [self.autocompleteTableView setHidden:YES];
}

@end
