//
//  EVCheckmarkLinkButton.h
//  Evenly
//
//  Created by Joseph Hankin on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCheckmarkButton.h"

@interface EVCheckmarkLinkButton : EVCheckmarkButton

- (void)setLinkDelegate:(id)delegate;
- (void)linkToUrl:(NSURL *)url forText:(NSString *)text;

@end
