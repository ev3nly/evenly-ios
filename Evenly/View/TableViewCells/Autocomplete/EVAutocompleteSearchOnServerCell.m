//
//  EVAutocompleteSearchOnServerCell.m
//  Evenly
//
//  Created by Joseph Hankin on 8/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompleteSearchOnServerCell.h"

#define X_MARGIN 10
#define Y_MARGIN 5

@interface EVAutocompleteSearchOnServerCell ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation EVAutocompleteSearchOnServerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.searchOnServerLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN,
                                                                             Y_MARGIN,
                                                                             self.contentView.frame.size.width - 2*X_MARGIN,
                                                                             (self.contentView.frame.size.height - 2*Y_MARGIN) / 2)];
        self.searchOnServerLabel.backgroundColor = [UIColor clearColor];
        self.searchOnServerLabel.font = [EVFont boldFontOfSize:15];
        self.searchOnServerLabel.textColor = [EVColor blueColor];
        self.searchOnServerLabel.textAlignment = NSTextAlignmentCenter;
        self.searchOnServerLabel.numberOfLines = 1;
        self.searchOnServerLabel.text = @"Search on server for:";
        self.searchOnServerLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self.contentView addSubview:self.searchOnServerLabel];
        
        
        self.searchQueryLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN,
                                                                          Y_MARGIN + (self.contentView.frame.size.height - 2*Y_MARGIN) / 2,
                                                                          self.contentView.frame.size.width - 2*X_MARGIN,
                                                                          (self.contentView.frame.size.height - 2*Y_MARGIN) / 2)];
        self.searchQueryLabel.backgroundColor = [UIColor clearColor];
        self.searchQueryLabel.font = [EVFont defaultFontOfSize:15];
        self.searchQueryLabel.textColor = [EVColor mediumLabelColor];
        self.searchQueryLabel.textAlignment = NSTextAlignmentCenter;
        self.searchQueryLabel.numberOfLines = 1;
        self.searchQueryLabel.text = @"\"\"";
        self.searchQueryLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self.contentView addSubview:self.searchQueryLabel];
        
        self.noResultsFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, self.contentView.frame.size.width - 2*X_MARGIN, self.contentView.frame.size.height - 2*Y_MARGIN)];
        self.noResultsFoundLabel.backgroundColor = [UIColor clearColor];
        self.noResultsFoundLabel.textColor = [EVColor mediumLabelColor];
        self.noResultsFoundLabel.font = [EVFont boldFontOfSize:15];
        self.noResultsFoundLabel.textAlignment = NSTextAlignmentCenter;
        self.noResultsFoundLabel.text = @"No results found";
        self.noResultsFoundLabel.hidden = YES;
        [self.contentView addSubview:self.noResultsFoundLabel];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.spinner setCenter:CGPointMake(self.contentView.frame.size.width / 2.0, self.contentView.frame.size.height / 2.0)];
        [self.spinner setAutoresizingMask:EV_AUTORESIZE_TO_CENTER];
        [self.spinner setHidesWhenStopped:YES];
        [self.contentView addSubview:self.spinner];
    }
    return self;
}

- (void)setSearchQuery:(NSString *)searchQuery {
    _searchQuery = searchQuery;
    if (!_searchQuery)
        self.searchQueryLabel.text = @"\"\"";
    else
        self.searchQueryLabel.text = [NSString stringWithFormat:@"\"%@\"", _searchQuery];
    [self setShowingNoResults:NO];
}

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    if (_loading) {
        self.searchOnServerLabel.hidden = YES;
        self.searchQueryLabel.hidden = YES;
        self.noResultsFoundLabel.hidden = YES;
        [self.spinner startAnimating];
    } else {
        if (!self.showingNoResults)
        {
            self.searchOnServerLabel.hidden = NO;
            self.searchQueryLabel.hidden = NO;
        }
        else
        {
            self.noResultsFoundLabel.hidden = NO;
        }
        [self.spinner stopAnimating];
    }
}

- (void)setShowingNoResults:(BOOL)showingNoResults {
    _showingNoResults = showingNoResults;
    if (_showingNoResults) {
        self.searchOnServerLabel.hidden = YES;
        self.searchQueryLabel.hidden = YES;
        self.noResultsFoundLabel.hidden = NO;
    } else {
        self.noResultsFoundLabel.hidden = YES;
        if (!self.loading)
        {
            self.searchOnServerLabel.hidden = NO;
            self.searchQueryLabel.hidden = NO;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
