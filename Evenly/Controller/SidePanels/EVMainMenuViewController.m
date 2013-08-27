//
//  EVMenuViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuViewController.h"
#import "EVNavigationManager.h"
#import "EVMainMenuCell.h"
#import "EVMainMenuFooter.h"
#import <Social/Social.h>
#import "OpenInChromeController.h"
#import "ABContactsHelper.h"

#define FOOTER_HEIGHT 60.0

@interface EVMainMenuViewController ()

@property (nonatomic, strong) EVMainMenuFooter *footerView;
@property (nonatomic, strong) UILabel *inviteBonusLabel;

@end

@implementation EVMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userSignedIn:)
                                                     name:EVSessionSignedInNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [EVColor sidePanelBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[EVMainMenuCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    [self loadFooter];
    [self loadInviteBonusLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self populateInviteBonusLabel];
    [self.tableView reloadData];
}

- (void)loadFooter {
    self.footerView = [[EVMainMenuFooter alloc] initWithFrame:CGRectMake(0,
                                                                         self.view.frame.size.height - FOOTER_HEIGHT,
                                                                         self.view.frame.size.width,
                                                                         FOOTER_HEIGHT)];
    [self.view addSubview:self.footerView];
}

- (void)loadInviteBonusLabel {
    self.inviteBonusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.inviteBonusLabel.textAlignment = NSTextAlignmentCenter;
    self.inviteBonusLabel.font = [EVFont defaultFontOfSize:15];
    self.inviteBonusLabel.textColor = [EVColor darkColor];
    self.inviteBonusLabel.backgroundColor = [UIColor clearColor];
}

- (void)populateInviteBonusLabel {
    NSInteger numberOfPotentialInvitees = MAX([[ABContactsHelper contacts] count], [[EVCIA me] facebookFriendCount]);
    NSInteger potentialDollars = (numberOfPotentialInvitees / EV_INVITES_NEEDED_FOR_PRIZE) * EV_DOLLARS_PER_PRIZE;
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:EV_STRING_FROM_INT(potentialDollars)];
    NSString *amountString = [EVStringUtility amountStringForAmount:number];
    self.inviteBonusLabel.text = [NSString stringWithFormat:@"Earn %@!", amountString];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVMainMenuOptionCOUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVMainMenuCell *cell = (EVMainMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *title = nil;
    UIImage *icon = nil;
    switch (indexPath.row) {
        case EVMainMenuOptionHome:
            title = @"Home";
            icon = [EVImages homeIcon];;
            break;
        case EVMainMenuOptionProfile:
            title = [[[EVCIA sharedInstance] me] name] ?: @"Profile";
            icon = [EVImages profileIcon];
            break;
        case EVMainMenuOptionSettings:
            title = @"Settings";
            icon = [EVImages settingsIcon];
            break;
        case EVMainMenuOptionSupport:
            title = @"Support";
            icon = [EVImages supportIcon];
            break;
        case EVMainMenuOptionInvite:
            title = @"Invite";
            icon = [EVImages inviteIcon];
            break;
            
        default:
            break;
    }
    icon = [EVImageUtility overlayImage:icon withColor:[EVColor blueColor] identifier:[NSString stringWithFormat:@"mainMenuIcon-%i", indexPath.row]];
    [cell.label setText:title];
    [cell.iconView setImage:icon];
    cell.marketingView = (indexPath.row == EVMainMenuOptionInvite ? self.inviteBonusLabel : nil);
    
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EVMainMenuOptionSupport)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Support" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        int buttonIndex = 0;
        [actionSheet addButtonWithTitle:@"Visit our FAQ Page"];
        buttonIndex++;
        
        if ([MFMailComposeViewController canSendMail]) {
            [actionSheet addButtonWithTitle:@"Email Us"];
            buttonIndex++;
        }
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"Tweet %@", [EVStringUtility supportTwitterHandle]]];
            buttonIndex++;
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet setCancelButtonIndex:buttonIndex];       
        
        [actionSheet showInView:self.view];
        return;
    }
    
    UIViewController *viewController = nil;
    switch (indexPath.row) {
        case EVMainMenuOptionHome:
            viewController = [[EVNavigationManager sharedManager] homeViewController];
            break;
        case EVMainMenuOptionProfile:
            viewController = [[EVNavigationManager sharedManager] profileViewController];
            break;
        case EVMainMenuOptionSettings:
            viewController = [[EVNavigationManager sharedManager] settingsViewController];
            break;
        case EVMainMenuOptionInvite:
            viewController = [[EVNavigationManager sharedManager] inviteViewController];
            break;
        case EVMainMenuOptionSupport:
        default:
            break;
    }
    if (viewController)
    {
        self.masterViewController.centerPanel = viewController;
    }
}

- (void)userSignedIn:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex])
        return;
    
    if (buttonIndex == EVSupportOptionFAQ)
    {
        OpenInChromeController *chromeController = [OpenInChromeController sharedInstance];
        if ([chromeController isChromeInstalled]) {
            [chromeController openInChrome:[EVStringUtility faqURL]
                           withCallbackURL:[NSURL URLWithString:@"evenly://home"]
                              createNewTab:YES];
        }
        else {
            [[UIApplication sharedApplication] openURL:[EVStringUtility faqURL]];
        }
        
    }
    else if ([MFMailComposeViewController canSendMail] && buttonIndex == EVSupportOptionEmail)
    {
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setToRecipients:@[ [EVStringUtility supportEmail] ]];
        [composer setSubject:[EVStringUtility supportEmailSubjectLine]];
        [composer setMailComposeDelegate:self];
        [self presentViewController:composer
                           animated:YES
                         completion:nil];
    }
    else
    {
        SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composer setInitialText:[NSString stringWithFormat:@"%@ ", [EVStringUtility supportTwitterHandle]]];
        [self presentViewController:composer
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - EVSidePanelViewController Overrides

- (JASidePanelState)visibleState {
    return JASidePanelLeftVisible;
}

@end
