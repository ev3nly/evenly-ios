//
//  EVGroupRequestEditViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVGroupRequest.h"

@interface EVGroupRequestEditViewController : EVModalViewController

@property (nonatomic, strong) EVGroupRequest *groupRequest;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

@end
