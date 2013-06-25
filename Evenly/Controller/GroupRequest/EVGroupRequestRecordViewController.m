//
//  EVGroupRequestRecordViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecordViewController.h"

@interface EVGroupRequestRecordViewController ()

@end

@implementation EVGroupRequestRecordViewController

- (id)initWithRecord:(EVGroupRequestRecord *)record {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.record = record;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
