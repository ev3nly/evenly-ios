//
//  EVRequestInitialView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRequestView.h"
#import "JSTokenField.h"
#import "EVRequestSwitch.h"

#import "EVUser.h"

@interface EVRequestInitialView : EVRequestView <EVSwitchDelegate, JSTokenFieldDelegate>

@property (nonatomic, strong) EVRequestSwitch *requestSwitch;
@property (nonatomic, strong) JSTokenField *toField;
@property (nonatomic, strong) UILabel *instructionLabel;

@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, weak) UITableView *autocompleteTableView;

- (void)addContact:(EVObject<EVExchangeable> *)contact;

@end
