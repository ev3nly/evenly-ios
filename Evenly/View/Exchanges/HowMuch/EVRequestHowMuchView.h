//
//  EVRequestHowMuchView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeHowMuchView.h"
#import "EVGrayButton.h"

@interface EVRequestHowMuchView : EVExchangeHowMuchView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) EVGrayButton *addOptionButton;

@property (nonatomic) BOOL showingMultipleOptions;

@property (nonatomic, readonly) NSArray *tiers;
@property (nonatomic, readonly) BOOL isValid;

- (void)setShowingMultipleOptions:(BOOL)showing animated:(BOOL)animated;

@end
