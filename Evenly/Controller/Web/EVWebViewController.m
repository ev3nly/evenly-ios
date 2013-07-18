//
//  EVWebViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWebViewController.h"
#import "EVLoadingIndicator.h"

#define LOADING_INDICATOR_TAG 7221

@interface EVWebViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) int loadingCounter;

@end

@implementation EVWebViewController

- (id)initWithURL:(NSURL *)url {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadWebView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = [self webViewFrame];
}

- (void)loadWebView {
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    if (self.url)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    
    if (self.webView)
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"should start: %i, %@", self.loadingCounter, request.URL);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"did start");
    self.loadingCounter++;
    if (![self.view viewWithTag:LOADING_INDICATOR_TAG]) {
        EVLoadingIndicator *indicator = [EVLoadingIndicator new];
        indicator.tag = LOADING_INDICATOR_TAG;
        indicator.autoresizingMask = EV_AUTORESIZE_TO_CENTER;
        [self.view addSubview:indicator];
        [indicator sizeToFit];
        indicator.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - indicator.bounds.size.width/2,
                                     CGRectGetMidY(self.view.bounds) - indicator.bounds.size.height/2,
                                     indicator.bounds.size.width,
                                     indicator.bounds.size.height);
        [indicator startAnimating];
    }

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadingCounter--;
    NSLog(@"did finish: %i", self.loadingCounter);
    
    EV_DISPATCH_AFTER(0.5, ^{
        EVLoadingIndicator *indicator = (EVLoadingIndicator *)[self.view viewWithTag:LOADING_INDICATOR_TAG];
        if (indicator && self.loadingCounter == 0) {
            [indicator stopAnimating];
        }
    });
}

- (CGRect)webViewFrame {
    return self.view.bounds;
}

@end
