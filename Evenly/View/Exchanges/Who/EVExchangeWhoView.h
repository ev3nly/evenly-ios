//
//  EVExchangeWhoView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeView.h"
#import "JSTokenField.h"

extern NSString *const EVExchangeWhoViewAddedTokenFromReturnPressNotification;

@interface EVExchangeWhoView : EVExchangeView <JSTokenFieldDelegate>

@property (nonatomic, strong) UIView *upperStripe;
@property (nonatomic, strong) JSTokenField *toField;
@property (nonatomic, strong) UIView *lowerStripe;

@property (nonatomic, weak) UITableView *autocompleteTableView;

@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic) NSInteger recipientCount;

- (void)addTokenFromField:(JSTokenField *)tokenField;
- (void)addContact:(EVObject<EVExchangeable> *)contact;
- (void)loadToField;

- (CGRect)upperStripeFrame;
- (CGRect)toFieldFrame;
- (CGRect)lowerStripeFrame;
- (CGRect)tableViewFrame;

@end
