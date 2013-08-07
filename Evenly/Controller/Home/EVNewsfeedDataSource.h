//
//  EVNewsfeedDataSource.h
//  Evenly
//
//  Created by Joseph Hankin on 8/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EVLoadingIndicator;

@interface EVNewsfeedDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) EVLoadingIndicator *loadingIndicator;

@property (nonatomic, strong) NSMutableArray *newsfeed;
@property (nonatomic, strong) NSMutableArray *locallyCreatedStories;
@property (nonatomic) int pageNumber;

- (void)loadNewestStories;
- (void)loadNextPage;
- (void)compareLocalStories;
- (void)storyWasCreatedLocally:(NSNotification *)notification;

@end
