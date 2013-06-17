//
//  EVAddCardViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAddCardViewController.h"
#import "EVCreditCard.h"
#import "EVNavigationBarButton.h"

@interface EVAddCardViewController ()

@property (nonatomic, strong) PKView *cardView;
@property (nonatomic, strong) EVCreditCard *creditCard;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) EVNavigationBarButton *saveButton;

- (void)saveCreditCard;
- (void)setLoading;
- (void)setError;
- (void)setSuccess;

@end

@implementation EVAddCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Add Card";
        self.creditCard = [[EVCreditCard alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.cardView = [[PKView alloc] initWithFrame:CGRectMake(15,15,290,55)];
    self.cardView.delegate = self;
    [self.view addSubview:self.cardView];

    [self loadSaveButton];
}

- (void)loadSaveButton {
    self.saveButton = [[EVNavigationBarButton alloc] initWithTitle:@"Save"];
    [self.saveButton addTarget:self action:@selector(saveBankAccount) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setLoading {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Validating Card";
    
    [self.cardView findAndResignFirstResponder];
}

- (void)setError {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.hud.labelText = @"Error";
    self.hud.mode = MBProgressHUDModeText;
    EV_DISPATCH_AFTER(1.0, ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)setSuccess {
    self.hud.labelText = @"Success!";
    self.hud.mode = MBProgressHUDModeText;
    EV_DISPATCH_AFTER(1.0, ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)saveCreditCard
{
    [self setLoading];
    
    [self.creditCard tokenizeWithSuccess:^{
        
        self.hud.labelText = @"Saving Card";
        
        [self.creditCard saveWithSuccess:^{
            
            NSDictionary *properties = (self.isDebitCard ? @{ @"cardType" : @"debit" } : @{ @"cardType" : @"credit" });
            [EVAnalyticsUtility trackEvent:EVAnalyticsAddedCard properties:properties];
            [[EVCIA sharedInstance] reloadCreditCardsWithCompletion:NULL];
            [self setSuccess];
        } failure:^(NSError *error){
            [self setError];
        }];
        
    } failure:^(NSError *error){
        [self setError];
    }];
}

#pragma mark - PKViewDelegate

- (void)paymentView:(PKView*)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
    DLog(@"Card number: %@", card.number);
    DLog(@"Card expiry: %lu/%lu", (unsigned long)card.expMonth, (unsigned long)card.expYear);
    DLog(@"Card cvc: %@", card.cvc);
    DLog(@"Address zip: %@", card.addressZip);
    
    self.creditCard.number = card.number;
    self.creditCard.cvv = card.cvc;
    self.creditCard.expirationMonth = [NSString stringWithFormat:@"%lu", (unsigned long)card.expMonth];
    self.creditCard.expirationYear = [NSString stringWithFormat:@"%lu", (unsigned long)card.expYear];
    
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

@end
