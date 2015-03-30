#import "IS_WebContentController.h"
#import "WebViewJavascriptBridge.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "IS_WebCoverView.h"
#import "LXActionSheet.h"
#import "SocialTool.h"
@interface IS_WebContentController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,IS_WebCoverViewDelegate,LXActionSheetDelegate,UIScrollViewDelegate>

@property WebViewJavascriptBridge* bridge;
@property (strong,nonatomic)IS_WebCoverView * webCoverView;
/*!
 *  封面图
 */
@property (strong,nonatomic)UIView * coverView;
@end

@implementation IS_WebContentController
{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar addSubview:_progressView];

//    [UIApplication sharedApplication].statusBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [UIApplication sharedApplication].statusBarHidden = NO;
    [_progressView removeFromSuperview];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"分享" themeColor:IS_SYSTEM_WHITE_COLOR target:self action:@selector(jumpToShare:)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" themeColor:IS_SYSTEM_WHITE_COLOR target:self action:@selector(backToRoot:)];
    
    [self setupSubView];
}
- (void)setupSubView{
    
    [self setupWebView];
    //[self setupProgress];
    [self setupCoverDetailView];
    [self loadAddress:_caseModel.url];
    
}
//- (void)setupCoverView{
//    
//    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
//    _coverView.backgroundColor = Color(0, 0, 0, 0);
//    [self.view addSubview:_coverView];
//    
//    
//}
- (void)setupCoverDetailView{
    
    _webCoverView = [[IS_WebCoverView alloc]initWithFrame:self.view.bounds];
    _webCoverView.delegate = self;
    _webCoverView.caseModel = _caseModel;
    [self.view addSubview:_webCoverView];
    
    
    
}

#pragma mark - 详情


- (void)setupWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = YES;
    _webView.contentMode = UIViewContentModeRedraw;
    _webView.opaque = YES;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.delegate =self;
    _webView.y = 100;
    
    [self.view addSubview:_webView];

}

- (void)setupProgress{
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progressBarView.backgroundColor = [UIColor greenColor];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];


}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    NSLog(@"contentOffset:%g",scrollView.contentOffset.y);
//}
#pragma mark - 封面视图
-(void)IS_WebCoverViewDidBackAction:(id)result{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)IS_WebCoverViewDidScroll:(id)result{
//    self.navigationController.navigationBarHidden = NO;

    [UIView animateWithDuration:0.8 animations:^{
        _webView.y=-20;
        _webView.height+=20;

    } completion:^(BOOL finished) {

    }];
    
}

-(void)jumpToShare:(id)item{
    LXActionSheet * AS = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信对话" otherButtonTitles:@[@"微信朋友圈"]];
    [AS showInView:self.view];
}
- (void)didClickOnButtonIndex:(NSInteger )buttonIndex{
    
    NSInteger index = buttonIndex;
    SocialPlatformType type = SocialPlatformTypeNone;
    if (index==2) {
        return;
    }
    type = index;
    
    [SocialTool  socialToolPlatformWithURLString:_caseModel.url Title:_caseModel.title Des:_caseModel.title Image:[UIImage imageNamed:@"IS_icon-1"] PlatformType:type];
    
}
-(void)backToRoot:(id)item{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - NJKWebViewProgressDelegate
- (void)loadAddress:(NSString *)url{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}
- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)setupJs{
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        

        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [UIView animateWithDuration:.3 animations:^{
            _coverView.y -=80;
            _webView.y=0;
        }];
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    

    [_bridge send:@"A string sent from ObjC after Webview has loaded."];
    
}

@end
