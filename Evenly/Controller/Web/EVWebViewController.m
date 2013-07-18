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
@property (nonatomic, strong) EVLoadingIndicator *loadingIndicator;
@property (atomic, assign) int loadingCounter;

@end

@implementation EVWebViewController

#pragma mark - Lifecycle

- (id)initWithURL:(NSURL *)url {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadWebView];
    [self loadLoadingIndicator];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = [self webViewFrame];
    self.loadingIndicator.frame = [self loadingIndicatorFrame];
}

#pragma mark - View Loading

- (void)loadWebView {
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    if (self.url)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)loadLoadingIndicator {
    self.loadingIndicator = [EVLoadingIndicator new];
    self.loadingIndicator.autoresizingMask = EV_AUTORESIZE_TO_CENTER;
    [self.view addSubview:self.loadingIndicator];
}

#pragma mark - Setters

- (void)setUrl:(NSURL *)url {
    _url = url;
    
    if (self.webView) {
        if (!self.loadingIndicator)
            [self loadLoadingIndicator];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadingCounter++;
    if (self.loadingIndicator)
        [self.loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadingCounter--;
    
    @synchronized (self) {
        if (self.loadingIndicator && self.loadingCounter == 0) {
            [self.loadingIndicator stopAnimating];
            self.loadingIndicator = nil;
        }
    }
}

#pragma mark - Frames

- (CGRect)webViewFrame {
    return self.view.bounds;
}

- (CGRect)loadingIndicatorFrame {
    [self.loadingIndicator sizeToFit];
    return CGRectMake(CGRectGetMidX(self.view.bounds) - self.loadingIndicator.bounds.size.width/2,
                      CGRectGetMidY(self.view.bounds) - self.loadingIndicator.bounds.size.height/2,
                      self.loadingIndicator.bounds.size.width,
                      self.loadingIndicator.bounds.size.height);
}

@end
