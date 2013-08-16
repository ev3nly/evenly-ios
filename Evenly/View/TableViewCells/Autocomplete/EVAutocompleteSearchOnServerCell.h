//
//  EVAutocompleteSearchOnServerCell.h
//  Evenly
//
//  Created by Joseph Hankin on 8/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompleteCell.h"

@interface EVAutocompleteSearchOnServerCell : EVAutocompleteCell

@property (nonatomic, strong) UILabel *searchOnServerLabel;
@property (nonatomic, strong) UILabel *searchQueryLabel;
@property (nonatomic, strong) NSString *searchQuery;

@property (nonatomic, strong) UILabel *noResultsFoundLabel;

@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL showingNoResults;

@end
