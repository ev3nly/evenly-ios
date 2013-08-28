//
//  EVInviteContactsViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteContactsViewController.h"
#import "EVInviteContactCell.h"
#import "ABContactsHelper.h"
#import <AddressBook/AddressBook.h>
#import "EVInvite.h"
#import "UIAlertView+MKBlockAdditions.h"

#define HEADER_HEIGHT 44
#define INVITE_BUTTON_WIDTH 70
#define INVITE_BUTTON_HEIGHT 36

#define HEADER_LABEL_X_ORIGIN 18
#define HEADER_LABEL_Y_ORIGIN 5
#define HEADER_LABEL_WIDTH 202

#define HEADER_BUTTON_X_ORIGIN 230

#define MIN_CONTACTS_TO_REQUIRE_CONFIRMATION 5

@interface EVInviteContactsViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton *headerButton;

@property (nonatomic) BOOL allSelected;

@end

@implementation EVInviteContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.fullFriendList = [[ABContactsHelper autocompletableContacts] sortedArrayUsingComparator:^NSComparisonResult(ABContact *obj1, ABContact *obj2) {
            NSComparisonResult result = [obj1.firstname.lowercaseString compare:obj2.firstname.lowercaseString];
            if (result == NSOrderedSame)
                result = [obj1.lastname.lowercaseString compare:obj2.lastname.lowercaseString];
            return result;
        }];
        self.displayedFriendList = self.fullFriendList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EVInviteContactCell class] forCellReuseIdentifier:@"contactInviteCell"];
    
    [self loadHeader];
}

- (void)loadHeader {
    self.headerView = [[UIView alloc] initWithFrame:[self headerViewFrame]];
    [self loadHeaderLabel];
    [self loadHeaderButton];
    [self setUpReactions];
}

- (void)loadHeaderLabel {
    self.headerLabel = [[UILabel alloc] initWithFrame:[self headerLabelFrame]];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor = [EVColor darkColor];
    self.headerLabel.font = [EVFont defaultFontOfSize:15];
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    self.headerLabel.text = @"Make it a party,\ninvite all your friends!";
    self.headerLabel.numberOfLines = 2;
    self.headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.headerView addSubview:self.headerLabel];
}

- (void)loadHeaderButton {
    self.headerButton = [[UIButton alloc] initWithFrame:[self headerButtonFrame]];
    [self.headerButton setBackgroundImage:[EVImages inviteButtonBackground] forState:UIControlStateNormal];
    [self.headerButton setBackgroundImage:[EVImages inviteButtonBackgroundSelected] forState:UIControlStateHighlighted];
    [self.headerButton addTarget:self action:@selector(inviteAllButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerButton setTitle:@"ADD ALL" forState:UIControlStateNormal];
    [self.headerButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    [self.headerButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    self.headerButton.titleLabel.font = [EVFont blackFontOfSize:11];
    
    [self.headerView addSubview:self.headerButton];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setUpReactions {
    [RACAble(self.selectedFriends) subscribeNext:^(NSArray *array) {
        if ([self.selectedFriends isEqualToArray:self.fullFriendList]) {
            UIImage *greenCheck = [EVImageUtility overlayImage:[EVImages checkIcon] withColor:[EVColor lightGreenColor] identifier:@"checkIcon"];
            [UIView animateWithDuration:0.3 animations:^{
                [self.headerButton setTitle:@"" forState:UIControlStateNormal];
                [self.headerButton setImage:greenCheck forState:UIControlStateNormal];
            }];
        } else {
            _allSelected = NO;
            [self.headerButton setTitle:@"ADD ALL" forState:UIControlStateNormal];
            [self.headerButton setImage:nil forState:UIControlStateNormal];
        }
    }];
    [self setAllSelected:YES];
}

- (void)inviteAllButtonPress:(UIButton *)sender {
    [self setAllSelected:!self.allSelected];
}

- (void)setAllSelected:(BOOL)allSelected {
    _allSelected = allSelected;
    if (_allSelected) {
        self.selectedFriends = [NSArray arrayWithArray:self.fullFriendList];
        [self.tableView reloadData];
    } else {
        self.selectedFriends = @[];
        [self.tableView reloadData];
    }
}

#pragma mark - Invite

- (void)inviteFriendsButtonPress:(id)sender {
    if ([self.selectedFriends count] > MIN_CONTACTS_TO_REQUIRE_CONFIRMATION) {
        [EVAnalyticsUtility trackEvent:EVAnalyticsPressedInviteFromContacts
                            properties:@{ @"friend_count" : @([self.selectedFriends count]) }];
        [[UIAlertView alertViewWithTitle:@"Confirmation"
                                 message:[NSString stringWithFormat:@"Ready to invite %d of your friends?", [self.selectedFriends count]]
                       cancelButtonTitle:@"Don't Invite"
                       otherButtonTitles:@[@"Invite"]
                               onDismiss:^(int buttonIndex) {
                                   [EVAnalyticsUtility trackEvent:EVAnalyticsConfirmedInviteFromContacts
                                                       properties:@{ @"friend_count" : @([self.selectedFriends count]) }];
                                   [self inviteFriends];
                               } onCancel:^{
                                   [EVAnalyticsUtility trackEvent:EVAnalyticsCanceledInviteFromContacts
                                                       properties:@{ @"friend_count" : @([self.selectedFriends count]) }];
                               }] show];
    } else {
        [self inviteFriends];
    }
}

- (void)inviteFriends {
    [self.view findAndResignFirstResponder];
    
    NSMutableArray *emails = [NSMutableArray array];
    NSMutableArray *phoneNumbers = [NSMutableArray array];
    for (ABContact *contact in self.selectedFriends) {
        if ([contact hasPhoneNumber])
            [phoneNumbers addObject:[EVStringUtility strippedPhoneNumber:[contact evenlyContactString]]];
        else
            [emails addObject:[[contact emailArray] objectAtIndex:0]];
    }
    
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING INVITES..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([emails count])
        [params setObject:emails forKey:@"emails"];
    if ([phoneNumbers count])
        [params setObject:phoneNumbers forKey:@"phone_numbers"];
    [EVInvite createWithParams:params
                       success:^(EVObject *object) {
                           [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                           self.selectedFriends = [NSArray array];
                           [self.tableView reloadData];
                       }
                       failure:^(NSError *error) {
                           [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                       }];
}

#pragma mark - TableView DataSource/Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVInviteContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contactInviteCell"];
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    
    ABContact *contact = [self.displayedFriendList objectAtIndex:indexPath.row];    

    [cell setName:[EVStringUtility displayNameForContact:contact]
        profilePicture:[EVImageUtility imageForContact:contact]];
    [cell.emailLabel setText:[contact evenlyContactString]];
    cell.identifier = contact;
    cell.handleSelection = ^(ABContact *friend) {
        if (![self.selectedFriends containsObject:friend])
            self.selectedFriends = [self.selectedFriends arrayByAddingObject:friend];
    };
    cell.handleDeselection = ^(ABContact *friend) {
        if ([self.selectedFriends containsObject:friend])
            self.selectedFriends = [self.selectedFriends arrayByRemovingObject:friend];
    };
    cell.shouldInvite = [self.selectedFriends containsObject:contact];
    
    return cell;
}

#pragma mark - Utility

- (NSArray *)filterArray:(NSArray *)array forSearch:(NSString *)search {
    return [array filter:^BOOL(ABContact *contact) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
        return ([name.lowercaseString rangeOfString:search.lowercaseString].location != NSNotFound);
    }];
}

#pragma mark - Frames 

- (CGRect)headerViewFrame {
    return CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT);
}

- (CGRect)headerLabelFrame {
    return CGRectMake(HEADER_LABEL_X_ORIGIN,
                      HEADER_LABEL_Y_ORIGIN,
                      HEADER_LABEL_WIDTH,
                      HEADER_HEIGHT);
}

- (CGRect)headerButtonFrame {
    return CGRectMake(HEADER_BUTTON_X_ORIGIN,
                      (HEADER_HEIGHT - INVITE_BUTTON_HEIGHT) / 2 + HEADER_LABEL_Y_ORIGIN,
                      INVITE_BUTTON_WIDTH,
                      INVITE_BUTTON_HEIGHT);
}

@end
