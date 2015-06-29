//
//  IS_WebController.m
//  iShare
//
//  Created by wusonghe on 15/3/31.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_WebController.h"
#import "WebViewJavascriptBridge.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@implementation IS_WebController
{
//    NJKWebViewProgressView *_progressView;
//    NJKWebViewProgress *_progressProxy;
}
//@property WebViewJavascriptBridge* bridge;

//- (void)setupProgress{
//
//    _progressProxy = [[NJKWebViewProgress alloc] init];
//    _webView.delegate = _progressProxy;
//    _progressProxy.webViewProxyDelegate = self;
//    _progressProxy.progressDelegate = self;
//
//    CGFloat progressBarHeight = 3.f;
//    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
//    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    _progressView.progressBarView.backgroundColor = [UIColor greenColor];
//
//}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //    [self.navigationController.navigationBar addSubview:_progressView];
    //    [UIApplication sharedApplication].statusBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    //    [UIApplication sharedApplication].statusBarHidden = NO;
    //    [_progressView removeFromSuperview];
    
}
- (void)setupJs{
    
    [WebViewJavascriptBridge enableLogging];
    
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
//        
//        
//        responseCallback(@"Response for message from ObjC");
//    }];
//    
//    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
//        [UIView animateWithDuration:.3 animations:^{
//            _webView.y=0;
//        }];
//        responseCallback(@"Response from testObjcCallback");
//    }];
//    
//    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
//        NSLog(@"objc got response! %@", responseData);
//    }];
//    
//    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
//    
//    
//    [_bridge send:@"A string sent from ObjC after Webview has loaded."];
    
}
@end
