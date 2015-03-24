//
//  BaseWebController.m
//  易商
//
//  Created by 伍松和 on 14/11/3.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseWebController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface BaseWebController ()<UIWebViewDelegate>


@end

@implementation BaseWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
}

#pragma mark- 控件
#pragma mark - Getters

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;

}

- (id)initWithAddress:(NSString *)urlString {
    
    self.URLString=urlString;
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.URL = pageURL;
        [self.webView loadRequest:[NSURLRequest requestWithURL:pageURL]];

    }
    
    return self;
}

- (void)loadURL:(NSURL *)pageURL {
    [self.webView loadRequest:[NSURLRequest requestWithURL:pageURL]];
}

-(UIWebView *)webView{

    if (!_webView) {
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _webView.scalesPageToFit=YES;
        _webView.delegate=self;
    }
    return _webView;
}
#pragma mark -视图开启


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
