//
//  EVNotificationsViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNotificationsViewController.h"

#import "EVFormView.h"
#import "EVFormRow.h"

@interface EVNotificationsViewController ()

@property (nonatomic, strong) UILabel *contextLabel;
@property (nonatomic, strong) EVFormView *form;

@end

@implementation EVNotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Notifications";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.view.frame.size.width - 40, 20)];
    self.contextLabel.backgroundColor = [UIColor clearColor];
    self.contextLabel.textColor = [EVColor inputTextColor];
    self.contextLabel.font = [EVFont blackFontOfSize:15];
    self.contextLabel.text = @"Send me notifications via...";
    [self.view addSubview:self.contextLabel];
    
    self.form = [[EVFormView alloc] initWithFrame:CGRectMake(10, 44.0, self.view.frame.size.width - 20, 150)];
    [self.view addSubview:self.form];
    
    EVFormRow *row = nil;
    CGRect rect = CGRectMake(0, 0, self.form.frame.size.width, 50.0);
    NSMutableArray *array = [NSMutableArray array];
    
    row = [[EVFormRow alloc] initWithFrame:rect];
    row.fieldLabel.text = @"Push";
    [array addObject:row];
    
    row = [[EVFormRow alloc] initWithFrame:rect];
    row.fieldLabel.text = @"Email";
    [array addObject:row];
    
    row = [[EVFormRow alloc] initWithFrame:rect];
    row.fieldLabel.text = @"SMS";
    [array addObject:row];
    
    [self.form setFormRows:array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
