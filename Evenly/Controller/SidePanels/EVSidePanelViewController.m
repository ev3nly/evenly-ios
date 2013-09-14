//
//  EVSidePanelViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSidePanelViewController.h"
#import "EVNavigationManager.h"

@interface EVSidePanelViewController ()

@end

@implementation EVSidePanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self observeSidePanelController];
}

- (void)dealloc {
    [self stopObservingSidePanelController];
}

- (JASidePanelState)visibleState {
    return JASidePanelCenterVisible; // abstract
}

- (void)observeSidePanelController {
    [[[EVNavigationManager sharedManager] masterViewController] addObserver:self
                                                                forKeyPath:@"state"
                                                                   options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                                   context:NULL];
}

- (void)stopObservingSidePanelController {
    [[[EVNavigationManager sharedManager] masterViewController] removeObserver:self forKeyPath:@"state"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.masterViewController && [keyPath isEqualToString:@"state"])
    {
        JASidePanelState oldState = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        JASidePanelState newState = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        if (oldState != newState)
        {
            if (newState == self.visibleState)
            {
                [self beginAppearanceTransition:YES animated:YES];
                [self endAppearanceTransition];
            }
            else if (oldState == self.visibleState)
            {
                [self beginAppearanceTransition:NO animated:YES];
                [self endAppearanceTransition];
            }
        }
    }
}

@end
