//
//  EVSidePanelViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@interface EVSidePanelViewController : EVViewController

- (JASidePanelState)visibleState;

- (void)observeSidePanelController;
- (void)stopObservingSidePanelController;

@end
