//
//  EVWebViewController.h
//  Evenly
//
//  Created by Justin Brunet on 7/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

@interface EVWebViewController : EVModalViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *url;

- (id)initWithURL:(NSURL *)url;

@end
