//
//  EVNewsfeedDataSource.m
//  Evenly
//
//  Created by Joseph Hankin on 8/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNewsfeedDataSource.h"
#import "EVStory.h"
#import "EVStoryCell.h"
#import "EVLoadingIndicator.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
@implementation EVNewsfeedDataSource

- (id)init {
    self = [super init];
    if (self) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignIn:) name:EVSessionSignedInNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOut:) name:EVSessionSignedOutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storyWasCreatedLocally:)
                                                     name:EVStoryLocallyCreatedNotification
                                                   object:nil];
        
        EVLoadingIndicator *customLoadingIndicator = [[EVLoadingIndicator alloc] initWithFrame:CGRectZero];
        [customLoadingIndicator sizeToFit];
        self.loadingIndicator = customLoadingIndicator;
        
        self.pageNumber = 1;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadNewestStories {
    if ([self.newsfeed count] == 0) {
        self.tableView.loading = YES;
        [self.tableView setShowsInfiniteScrolling:NO];
    }
    
    [EVUser newsfeedWithSuccess:^(NSArray *newsfeed) {
        [self mergeNewStories:newsfeed];
        [self compareLocalStories];
        EV_PERFORM_ON_MAIN_QUEUE(^{
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            self.tableView.loading = NO;
            [self.tableView setShowsInfiniteScrolling:YES];
        });
    } failure:^(NSError *error) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            [self.tableView.pullToRefreshView stopAnimating];
            self.tableView.loading = NO;
            [self.tableView setShowsInfiniteScrolling:YES];
        });
    }];
}

- (void)mergeNewStories:(NSArray *)newStories {
    if ([newStories count] == 0)
        return;
    
    EVStory *firstOldStory = [self.newsfeed objectAtIndex:0];
    int i = 0;
    do {
        EVStory *firstNewStory = [newStories objectAtIndex:0];
        if ([[firstNewStory createdAt] compare:[firstOldStory createdAt]] == NSOrderedAscending)
            break;
        i++;
    } while (i < [newStories count]);
    
    
    self.newsfeed = [NSMutableArray arrayWithArray:newStories];
}

- (void)loadNextPage {
    self.pageNumber++;
    [self.tableView.infiniteScrollingView startAnimating];
    [self.loadingIndicator startAnimating];
    [EVUser newsfeedStartingAtPage:self.pageNumber
                           success:^(NSArray *history) {
                               if ([history count] == 0) {
                                   self.pageNumber--;
                                   DLog(@"No entries, reverted page number to %d", self.pageNumber);
                               }
                               [self.newsfeed addObjectsFromArray:history];
                               [self.tableView reloadData];
                               [self.tableView.infiniteScrollingView stopAnimating];
                               [self.loadingIndicator stopAnimating];
                           } failure:^(NSError *error) {
                               DLog(@"error: %@", error);
                               self.pageNumber--;
                               DLog(@"Error, reverted page number to %d", self.pageNumber);
                               [self.tableView.infiniteScrollingView stopAnimating];
                               [self.loadingIndicator stopAnimating];
                           }];
}

- (void)compareLocalStories {
    if ([self.locallyCreatedStories count] == 0)
        return;
    
    EVStory *mostRecentLocalStory = [self.locallyCreatedStories objectAtIndex:0];
    EVStory *mostRecentRemoteStory = [self.newsfeed objectAtIndex:0];
    
    // Remote story is older than local story
    if ([mostRecentRemoteStory.createdAt compare:mostRecentLocalStory.createdAt] == NSOrderedAscending) {
        
        // Remove stories older than an hour.
        NSArray *locals = [NSArray arrayWithArray:self.locallyCreatedStories];
        NSDate *anHourAgo = [NSDate dateWithTimeIntervalSinceNow:(-EVStoryLocalMaxLifespan)];
        for (EVStory *localStory in locals) {
            if ([[localStory createdAt] isEarlierThan:anHourAgo]) {
                [self.locallyCreatedStories removeObject:localStory];
            }
        }
    }
    // Remote story is newer than most recent local story
    else {
        [self.locallyCreatedStories removeAllObjects];
    }
    
    if ([self.locallyCreatedStories count] > 0) {
        self.newsfeed = [NSMutableArray arrayWithArray:[self.locallyCreatedStories arrayByAddingObjectsFromArray:self.newsfeed]];
    }
}

- (void)storyWasCreatedLocally:(NSNotification *)notification {
    EVStory *story = [[notification userInfo] objectForKey:@"story"];
    [self.locallyCreatedStories insertObject:story atIndex:0];
    
    self.newsfeed = [NSMutableArray arrayWithArray:[self.locallyCreatedStories arrayByAddingObjectsFromArray:self.newsfeed]];
}


- (void)didSignIn:(NSNotification *)notification {
    [self loadNewestStories];
}

- (void)didSignOut:(NSNotification *)notification {
    self.newsfeed = [NSArray array];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self.newsfeed count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    EVStory *story = [self.newsfeed objectAtIndex:indexPath.section];
    cell.story = story;
    return cell;
}

@end
