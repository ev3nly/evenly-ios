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

#import "EVCharge.h"

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
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleAmountView = [[EVRequestSingleAmountView alloc] initWithFrame:[self contentViewFrame]];
    self.singleAmountView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleDetailsView = [[EVRequestDetailsView alloc] initWithFrame:[self.view bounds]];
    self.singleDetailsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;    
    [self.singleDetailsView addSubview:self.privacySelector];
    
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

    // Handle the first screen: if it's a group request, and if not, if it has at least one recipient.
    RAC(self.isGroupRequest) = RACAble(self.initialView.requestSwitch.on);
    
    [RACAble(self.isGroupRequest) subscribeNext:^(NSNumber *isGroupRequest) {
        [self validateForPhase:EVRequestPhaseWho];
    }];
    
    [RACAble(self.initialView.recipientCount) subscribeNext:^(NSNumber *hasRecipients) {
        [self validateForPhase:EVRequestPhaseWho];
    }];
    
    // SECOND SCREEN:
    // Single:
    [self.singleAmountView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        [self validateForPhase:EVRequestPhaseHowMuch];
    }];
    
    // Multiple:
    
    // THIRD SCREEN:
    // Single
    [self.singleDetailsView.descriptionField.rac_textSignal subscribeNext:^(NSString *descriptionString) {
        [self validateForPhase:EVRequestPhaseWhatFor];
    }];
}

- (void)validateForPhase:(EVRequestPhase)phase {
    UIButton *button = [self rightButtonForPhase:phase];
    if (phase == EVRequestPhaseWho)
    {
        if (self.isGroupRequest) {
            [button setEnabled:YES];
        } else {
            [button setEnabled:(BOOL)self.initialView.recipientCount];
        }
    }
    else if (phase == EVRequestPhaseHowMuch)
    {
        if (!self.isGroupRequest)
        {
            float amount = [[EVStringUtility amountFromAmountString:self.singleAmountView.amountField.text] floatValue];
            [button setEnabled:(amount >= EV_MINIMUM_EXCHANGE_AMOUNT)];
        }
    }
    else if (phase == EVRequestPhaseWhatFor)
    {
        if (!self.isGroupRequest)
            [button setEnabled:!EV_IS_EMPTY_STRING(self.singleDetailsView.descriptionField.text)];
    }
}

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)backButtonPress:(id)sender {
    [self popViewAnimated:YES];
    self.phase--;
    [self setUpNavBar];
    [self validateForPhase:self.phase];
}

- (void)nextButtonPress:(id)sender {
    if (self.phase == EVRequestPhaseWho)
    {
        self.autocompleteDataSource.suggestions = [NSArray array];
        self.autocompleteTableView.hidden = YES;
        if (!self.isGroupRequest)
        {
            self.exchange = [[EVCharge alloc] init];
            EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
            self.exchange.to = recipient;
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
        if (!self.isGroupRequest)
        {
            self.exchange.amount = [EVStringUtility amountFromAmountString:self.singleAmountView.amountField.text];
            NSString *title = [NSString stringWithFormat:@"%@ owes me %@", self.exchange.to.name, [EVStringUtility amountStringForAmount:self.exchange.amount]];
            [self.singleDetailsView.titleLabel setText:title];
            [self pushView:self.singleDetailsView animated:YES];
        }
        else
        {
            
        }
        self.phase = EVRequestPhaseWhatFor;
    }
    [self setUpNavBar];
    [self validateForPhase:self.phase];
}

- (void)requestButtonPress:(id)sender {
    // TODO: Verify this works for group charge as well.
    
    if (!self.isGroupRequest)
    {
        self.exchange.memo = self.singleDetailsView.descriptionField.text;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.exchange saveWithSuccess:^{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Success!";
            
            EV_DISPATCH_AFTER(1.0, ^(void) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                }];
            });
        } failure:^(NSError *error) {
            DLog(@"failed to create %@", NSStringFromClass([self.exchange class]));
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)setUpNavBar {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]] animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self rightButtonForPhase:self.phase]] animated:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
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
